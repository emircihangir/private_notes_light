import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/encryption/application/master_key.dart';
import 'package:private_notes_light/features/notes/application/filtered_notes_list.dart';
import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/application/search_query.dart';
import 'package:private_notes_light/features/notes/domain/note_controller_state.dart';
import 'package:private_notes_light/features/notes/domain/note_widget_data.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    container.read(masterKeyProvider.notifier).set(enc.Key.fromLength(32));
    addTearDown(container.dispose);
  });

  group('SearchQuery tests ->', () {
    test('set updates search query state', () {
      // Act
      container.read(searchQueryProvider.notifier).set('meeting');

      // Verify
      expect(container.read(searchQueryProvider), 'meeting');
    });
  });

  group('filteredNotesList tests ->', () {
    test('returns all notes when search query is empty', () {
      // Setup
      final notes = [const NoteWidgetData(noteId: '1', noteTitle: 'Shopping list'), const NoteWidgetData(noteId: '2', noteTitle: 'Meeting notes')];
      container.read(noteControllerProvider.notifier).setState(NoteControllerState(data: notes));

      // Act & Verify
      expect(container.read(filteredNotesListProvider), notes);
    });

    test('filters notes by title case-insensitively', () {
      // Setup
      final notes = [
        const NoteWidgetData(noteId: '1', noteTitle: 'Shopping list'),
        const NoteWidgetData(noteId: '2', noteTitle: 'Meeting notes'),
        const NoteWidgetData(noteId: '3', noteTitle: 'MEETING follow-up'),
      ];
      container.read(noteControllerProvider.notifier).setState(NoteControllerState(data: notes));
      container.read(searchQueryProvider.notifier).set('meeting');

      // Act
      final filteredNotes = container.read(filteredNotesListProvider);

      // Verify
      expect(filteredNotes, [notes[1], notes[2]]);
    });
  });
}
