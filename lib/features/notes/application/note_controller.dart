import 'package:private_notes_light/features/encryption/application/encryption_service.dart';
import 'package:private_notes_light/features/encryption/application/master_key.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/note.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/notes/domain/note_widget_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:encrypt/encrypt.dart' as enc;

part 'note_controller.g.dart';

@riverpod
class NoteController extends _$NoteController {
  @override
  Future<List<NoteWidgetData>> build() async {
    final masterKeyString = ref.watch(masterKeyProvider);
    if (masterKeyString == null) return [];

    final List<NoteDto> dtos = await ref.read(noteRepositoryProvider).getNotes();

    final List<NoteWidgetData> result = [];
    for (NoteDto dto in dtos) {
      result.add(NoteWidgetData(noteId: dto.id, noteTitle: dto.title));
    }

    return result;
  }

  Future<void> createNote({
    String? id,
    required String title,
    required String content,
    DateTime? date,
  }) async {
    final encrypted = ref.read(encryptionServiceProvider).encryptWithMasterKey(content);

    Note encryptedNote = Note(
      id: id ?? Uuid().v4(),
      title: title,
      content: encrypted.encryptedText,
      dateCreated: date ?? DateTime.now(),
    );

    final NoteDto dto = NoteDto.fromDomain(
      encryptedNote,
      encryptedNote.content,
      encrypted.encryptionIV,
    );

    await ref.read(noteRepositoryProvider).addNote(dto);

    ref.invalidateSelf();
  }

  Future<void> removeNote(String noteId) async {
    final currentList = state.value;
    if (currentList == null) return;

    state = AsyncValue.data(currentList.where((element) => element.noteId != noteId).toList());
    try {
      await ref.read(noteRepositoryProvider).removeNote(noteId);
    } catch (e) {
      ref.invalidateSelf();
      rethrow;
    }
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
