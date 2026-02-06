import 'package:private_notes_light/domain/note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'note_controller.g.dart';

@riverpod
class NoteController extends _$NoteController {
  @override
  FutureOr<List<Note>> build() {
    return []; // TODO: Implement the build logic.
  }

  void createNote({required String title, String? content}) {
    Note newNote = Note(
      id: Uuid().v4(),
      title: title,
      content: content ?? '',
      dateCreated: DateTime.now(),
    );

    // Send it to note_repository
  }
}
