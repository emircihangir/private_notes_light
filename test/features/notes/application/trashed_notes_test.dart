import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/notes/application/trashed_notes.dart';
import 'package:private_notes_light/features/notes/domain/note_widget_data.dart';
import 'package:private_notes_light/features/notes/domain/trashed_note_data.dart';

void main() {
  group('TrashedNotes tests ->', () {
    test('add works', () async {
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
  });
}
