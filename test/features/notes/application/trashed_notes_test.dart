import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/notes/application/trashed_notes.dart';
import 'package:private_notes_light/features/notes/domain/note_widget_data.dart';
import 'package:private_notes_light/features/notes/domain/trashed_note_data.dart';

void main() {
  group('TrashedNotes tests ->', () {
    test('add works', () {
      // Setup
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final before = container.read(trashedNotesProvider);
      final dummyValue = TrashedNoteData(NoteWidgetData(noteId: '', noteTitle: ''), 0);

      // Act
      container.read(trashedNotesProvider.notifier).add(dummyValue);

      // Verify
      final after = container.read(trashedNotesProvider);
      expect(after.length - before.length, 1);
      expect(after.contains(dummyValue), isTrue);
    });

    test('undoLast works', () {
      // Setup
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final dummyValue1 = TrashedNoteData(NoteWidgetData(noteId: '', noteTitle: ''), 0);
      final dummyValue2 = TrashedNoteData(NoteWidgetData(noteId: '', noteTitle: ''), 1);
      container.read(trashedNotesProvider.notifier).add(dummyValue1);
      container.read(trashedNotesProvider.notifier).add(dummyValue2);

      // Act
      final retrievedValue = container.read(trashedNotesProvider.notifier).undoLast();

      // Verify
      final after = container.read(trashedNotesProvider);
      expect(retrievedValue, dummyValue2);
      expect(after.length, 1);
      expect(after.contains(dummyValue1), isTrue);
      expect(after.contains(dummyValue2), isFalse);
    });
  });
}
