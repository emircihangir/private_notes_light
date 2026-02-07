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

  Future<void> createNote({required String title, required String content}) async {
    Note newNote = Note(
      id: Uuid().v4(),
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
}
