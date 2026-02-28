import 'dart:developer';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/trashed_note_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trashed_notes.g.dart';

@Riverpod(keepAlive: true)
class TrashedNotes extends _$TrashedNotes {
  @override
  List<TrashedNoteData> build() => [];

  void add(TrashedNoteData trashedNoteData) => state = [...state, trashedNoteData];

  TrashedNoteData undoLast() {
    final stateCopy = List<TrashedNoteData>.from(state);
    final lastDeletedNote = stateCopy.removeLast();
    state = stateCopy;
    return lastDeletedNote;
  }

  Future<void> emptyTrash() async {
    if (state.isEmpty) return;

    for (TrashedNoteData trashedNote in state) {
      await ref.read(noteRepositoryProvider).removeNote(trashedNote.noteWidgetData.noteId);
    }
    state = [];
    log('Emptied the trash.', name: 'INFO');
  }

  void putBack(TrashedNoteData value) => state = state.where((e) => e != value).toList();
}
