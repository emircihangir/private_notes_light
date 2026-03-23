import 'dart:developer';
import 'package:meta/meta.dart';
import 'package:private_notes_light/features/authentication/application/auth_service.dart';
import 'package:private_notes_light/features/backup/application/export_service.dart';
import 'package:private_notes_light/features/backup/data/backup_repository.dart';
import 'package:private_notes_light/features/encryption/application/encryption_service.dart';
import 'package:private_notes_light/features/encryption/application/master_key.dart';
import 'package:private_notes_light/features/notes/application/trashed_notes.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/note.dart';
import 'package:private_notes_light/features/notes/domain/note_controller_state.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/notes/domain/note_widget_data.dart';
import 'package:private_notes_light/features/notes/domain/trashed_note_data.dart';
import 'package:private_notes_light/features/settings/data/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart' as enc;

part 'note_controller.g.dart';

@riverpod
class NoteController extends _$NoteController {
  @override
  Future<NoteControllerState> build() async {
    final masterKey = ref.read(masterKeyProvider);
    assert(masterKey != null, 'masterKey cannot be null when NoteController initializes.');

    final List<NoteDto> dtos = await ref.read(noteRepositoryProvider).getNotes();

    final List<NoteWidgetData> result = [];
    for (NoteDto dto in dtos) {
      result.add(NoteWidgetData(noteId: dto.id, noteTitle: dto.title));
    }

    return NoteControllerState(data: result);
  }

  @visibleForTesting
  void setState(NoteControllerState newState) => state = AsyncValue.data(newState);

  Future<void> createNote({
    String? id,
    required String title,
    required String content,
    DateTime? date,
  }) async {
    final encrypted = ref.read(encryptionServiceProvider).encryptWithMasterKey(content);
    Note newNote = Note(
      id: id ?? const Uuid().v4(),
      title: title,
      content: encrypted.encryptedText,
      dateCreated: date ?? DateTime.now(),
    );
    final NoteDto dto = NoteDto.fromDomain(newNote, newNote.content, encrypted.encryptionIV.base64);

    await ref.read(noteRepositoryProvider).addNote(dto);

    ref.invalidateSelf();
    await suggestExportIfPreferred();
    await warnExportIfValid();
  }

  Future<void> suggestExportIfPreferred() async {
    final preferred = await getExportSuggestionPref();

    if (preferred) {
      state = AsyncValue.data(state.value!.copyWith(suggestExport: true));
    }
  }

  Future<void> warnExportIfValid() async {
    final settingsRepo = await ref.read(settingsRepositoryProvider.future);
    if (settingsRepo.getSettings().exportWarnings == false) return;

    final backupRepo = await ref.read(backupRepositoryProvider.future);
    final lastExportDate = await backupRepo.getLastExportDate();
    if (lastExportDate == null) return;

    final now = DateTime.now();
    final diff = now.difference(lastExportDate);
    if (diff > const Duration(days: 7)) {
      state = AsyncValue.data(state.value!.copyWith(warnExport: true));
    }
  }

  Future<void> triggerExport() async {
    final exportResult = await ref.read(exportServiceProvider.future);
    if (exportResult == true) {
      state = AsyncValue.data(state.value!.copyWith(showExportSuccessful: true));
    } else {
      state = AsyncValue.data(
        state.value!.copyWith(showError: true, errorKind: NoteErrorKind.failedToExport),
      );
    }
  }

  void moveNoteToTrash(NoteWidgetData noteWidgetData) {
    final currentList = state.value!.data;

    final trashdNoteData = TrashedNoteData(noteWidgetData, currentList.indexOf(noteWidgetData));
    ref.read(trashedNotesProvider.notifier).add(trashdNoteData);
    final newList = currentList
        .where((element) => element.noteId != noteWidgetData.noteId)
        .toList();
    state = AsyncValue.data(state.value!.copyWith(data: newList));
    if (state.value!.showInfo != true) {
      state = AsyncValue.data(
        state.value!.copyWith(showInfo: true, infoKind: InfoKind.noteDeleted),
      );
    }

    log('Note with the title "${noteWidgetData.noteTitle}" trashed.', name: 'INFO');
  }

  void undoDelete() {
    final currentList = state.value!.data;

    final lastDeletedNote = ref.read(trashedNotesProvider.notifier).undoLast();
    final newList = List<NoteWidgetData>.from(currentList);
    late final int noteIndex;
    if (lastDeletedNote.index > newList.length) {
      noteIndex = newList.length;
    } else {
      noteIndex = lastDeletedNote.index;
    }
    newList.insert(noteIndex, lastDeletedNote.noteWidgetData);
    state = AsyncValue.data(state.value!.copyWith(data: newList));

    log(
      'Put back the note with title "${lastDeletedNote.noteWidgetData.noteTitle}".',
      name: 'INFO',
    );
  }

  void putNoteBack(TrashedNoteData trashedNote) {
    final currentList = state.value!.data;

    final newList = List<NoteWidgetData>.from(currentList);
    late final int noteIndex;
    if (trashedNote.index > newList.length) {
      noteIndex = newList.length;
    } else {
      noteIndex = trashedNote.index;
    }

    newList.insert(noteIndex, trashedNote.noteWidgetData);
    state = AsyncValue.data(state.value!.copyWith(data: newList));

    ref.read(trashedNotesProvider.notifier).putBack(trashedNote);

    log('Put back the note with title "${trashedNote.noteWidgetData.noteTitle}".', name: 'INFO');
  }

  Future<void> logout() async {
    await ref.read(trashedNotesProvider.notifier).emptyTrash();
    ref.read(authServiceProvider).logout();
  }

  Future<bool> getExportSuggestionPref() async {
    final settingsRepo = await ref.watch(settingsRepositoryProvider.future);
    return settingsRepo.getSettings().exportSuggestions;
  }

  Future<Note> openNote(String noteId) async {
    final NoteDto dto = await ref.read(noteRepositoryProvider).getNote(noteId);
    final decryptedContent = ref
        .read(encryptionServiceProvider)
        .decryptWithMasterKey(dto.content, enc.IV.fromBase64(dto.iv));
    return Note(
      id: dto.id,
      title: dto.title,
      content: decryptedContent,
      dateCreated: DateTime.parse(dto.dateCreated),
    );
  }

  // Consume functions
  void consumeExportWarning() {
    state = AsyncValue.data(state.value!.copyWith(warnExport: false));
  }

  void consumeExportSuggestion() {
    state = AsyncValue.data(state.value!.copyWith(suggestExport: false));
  }

  void consumeInfoSnackbar() {
    state = AsyncValue.data(state.value!.copyWith(showInfo: false, infoKind: null));
  }

  void consumeError() {
    state = AsyncValue.data(state.value!.copyWith(showError: false, errorKind: null));
  }

  void consumeExportSuccess() {
    state = AsyncValue.data(state.value!.copyWith(showExportSuccessful: false));
  }
}
