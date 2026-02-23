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

  void clear() => state = [];

  void remove(TrashedNoteData value) => state = state.where((e) => e != value).toList();
}
