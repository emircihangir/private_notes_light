import 'package:private_notes_light/features/authentication/application/auth_service.dart';
import 'package:private_notes_light/features/backup/application/export_service.dart';
import 'package:private_notes_light/features/encryption/application/encryption_service.dart';
import 'package:private_notes_light/features/encryption/application/master_key.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/note.dart';
import 'package:private_notes_light/features/notes/domain/note_controller_state.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/notes/domain/note_widget_data.dart';
import 'package:private_notes_light/features/settings/data/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart' as enc;

part 'note_controller.g.dart';

@riverpod
class NoteController extends _$NoteController {
  @override
  Future<NoteControllerState?> build() async {
    final masterKeyString = ref.watch(masterKeyProvider);
    if (masterKeyString == null) return null;

    final List<NoteDto> dtos = await ref.read(noteRepositoryProvider).getNotes();

    final List<NoteWidgetData> result = [];
    for (NoteDto dto in dtos) {
      result.add(NoteWidgetData(noteId: dto.id, noteTitle: dto.title));
    }

    return NoteControllerState(data: result);
  }

  Future<void> createNote({
    String? id,
    required String title,
    required String content,
    DateTime? date,
  }) async {
    final encrypted = ref.read(encryptionServiceProvider).encryptWithMasterKey(content);

    Note newNote = Note(
      id: id ?? Uuid().v4(),
      title: title,
      content: encrypted.encryptedText,
      dateCreated: date ?? DateTime.now(),
    );

    final NoteDto dto = NoteDto.fromDomain(newNote, newNote.content, encrypted.encryptionIV);

    await ref.read(noteRepositoryProvider).addNote(dto);

    // * Update the state.
    final previousList = state.valueOrNull?.data;
    if (previousList == null) return;
    final newList = [...previousList, NoteWidgetData(noteId: newNote.id, noteTitle: newNote.title)];
    state = AsyncValue.data(state.value!.copyWith(data: newList));
    await suggestExportIfPreferred();
  }

  Future<void> suggestExportIfPreferred() async {
    final preferred = await getExportSuggestionPref();

    if (preferred) {
      state = AsyncValue.data(state.valueOrNull?.copyWith(suggestExport: true));
    }
  }

  void consumeExportSuggestion() {
    state = AsyncValue.data(state.valueOrNull?.copyWith(suggestExport: false));
  }

  Future<void> triggerExport() async {
    final exportResult = await ref.read(exportServiceProvider.future);
    if (exportResult == true) {
      state = AsyncValue.data(state.valueOrNull?.copyWith(showExportSuccessful: true));
    }
  }

  void consumeExportSuccess() {
    state = AsyncValue.data(state.valueOrNull?.copyWith(showExportSuccessful: false));
  }

  Future<void> removeNote(String noteId) async {
    final currentList = state.valueOrNull?.data;
    if (currentList == null) return;

    final newList = currentList.where((element) => element.noteId != noteId).toList();
    state = AsyncValue.data(state.value!.copyWith(data: newList));
    try {
      await ref.read(noteRepositoryProvider).removeNote(noteId);
      suggestExportIfPreferred();
    } catch (e) {
      state = AsyncValue.data(
        state.value?.copyWith(showError: true, errorKind: NoteErrorKind.failedToDeleteNote),
      );
    }
  }

  void consumeError() {
    state = AsyncValue.data(state.value?.copyWith(showError: false, errorKind: null));
  }

  void logout() => ref.read(authServiceProvider).logout();

  Future<bool> getExportSuggestionPref() async {
    final settingsRepo = await ref.watch(settingsRepositoryProvider.future);
    return settingsRepo.getSettings().exportSuggestions;
  }

  Future<Note> openNote(String noteId) async {
    final NoteDto dto = await ref.read(noteRepositoryProvider).getNote(noteId);
    return Note(
      id: dto.id,
      title: dto.title,
      content: ref
          .read(encryptionServiceProvider)
          .decryptWithMasterKey(dto.content, enc.IV.fromBase64(dto.iv)),
      dateCreated: DateTime.parse(dto.dateCreated),
    );
  }
}
