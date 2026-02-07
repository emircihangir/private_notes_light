import 'package:private_notes_light/application/encryption_service.dart';
import 'package:private_notes_light/application/master_key.dart';
import 'package:private_notes_light/data/note_repository.dart';
import 'package:private_notes_light/domain/note.dart';
import 'package:private_notes_light/domain/note_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'note_controller.g.dart';

@riverpod
class NoteController extends _$NoteController {
  @override
  Future<List<({String noteID, String noteTitle})>> build() async {
    final masterKeyString = ref.watch(masterKeyProvider);
    if (masterKeyString == null) return [];

    final List<NoteDto> dtos = await ref.read(noteRepositoryProvider).getNotes();

    final List<({String noteID, String noteTitle})> result = [];
    for (NoteDto dto in dtos) {
      result.add((noteID: dto.id, noteTitle: dto.title));
    }

    return result;
  }

  Future<void> createNote({String? id, required String title, required String content}) async {
    Note newNote = Note(
      id: id ?? Uuid().v4(),
      title: title,
      content: content,
      dateCreated: DateTime.now(),
    );

    final encrypted = ref
        .read(encryptionServiceProvider.notifier)
        .encryptWithMasterKey(newNote.content);

    Note encryptedNote = newNote.copyWith(content: encrypted.encryptedText);

    final NoteDto dto = NoteDto.fromDomain(
      encryptedNote,
      encryptedNote.content,
      encrypted.encryptionIV,
    );

    await ref.read(noteRepositoryProvider).addNote(dto);

    ref.invalidateSelf();
  }

  Future<void> removeNote(String noteID) async {
    final currentList = state.value;
    if (currentList == null) return;

    state = AsyncValue.data(currentList.where((element) => element.noteID != noteID).toList());
    try {
      await ref.read(noteRepositoryProvider).removeNote(noteID);
    } catch (e) {
      ref.invalidateSelf();
      rethrow;
    }
  }

  Future<Note> openNote(String noteID) async {
    final NoteDto dto = await ref.read(noteRepositoryProvider).getNote(noteID);
    return Note(
      id: dto.id,
      title: dto.title,
      content: ref
          .read(encryptionServiceProvider.notifier)
          .decryptWithMasterKey(dto.content, dto.iv),
      dateCreated: DateTime.parse(dto.dateCreated),
    );
  }
}
