import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:private_notes_light/features/notes/application/trashed_notes.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/note_widget_data.dart';
import 'package:private_notes_light/features/notes/domain/trashed_note_data.dart';

@GenerateNiceMocks([MockSpec<NoteRepository>()])
import 'trashed_notes_test.mocks.dart';

void main() {
  late MockNoteRepository mockNoteRepo;

  setUp(() {
    mockNoteRepo = MockNoteRepository();
  });

  group('TrashedNotes tests ->', () {
    test('add works', () {
      // Setup
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final before = container.read(trashedNotesProvider);
      final dummyValue = const TrashedNoteData(NoteWidgetData(noteId: '', noteTitle: ''), 0);

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

      final dummyValue1 = const TrashedNoteData(NoteWidgetData(noteId: '', noteTitle: ''), 0);
      final dummyValue2 = const TrashedNoteData(NoteWidgetData(noteId: '', noteTitle: ''), 1);
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

    test('emptyTrash works', () async {
      // Setup
      final container = ProviderContainer(
        overrides: [noteRepositoryProvider.overrideWith((ref) => mockNoteRepo)],
      );
      addTearDown(container.dispose);

      final dummyValue1 = const TrashedNoteData(NoteWidgetData(noteId: '', noteTitle: ''), 0);
      final dummyValue2 = const TrashedNoteData(NoteWidgetData(noteId: '', noteTitle: ''), 1);
      container.read(trashedNotesProvider.notifier).add(dummyValue1);
      container.read(trashedNotesProvider.notifier).add(dummyValue2);

      // Act
      await container.read(trashedNotesProvider.notifier).emptyTrash();

      // Verify
      final after = container.read(trashedNotesProvider);
      expect(after.length, 0);
      verify(mockNoteRepo.batchDelete(argThat(isA<List<String>>()))).called(1);
    });

    test('putBack works', () {
      // Setup
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final dummyValue1 = const TrashedNoteData(NoteWidgetData(noteId: '', noteTitle: ''), 0);
      final dummyValue2 = const TrashedNoteData(NoteWidgetData(noteId: '', noteTitle: ''), 1);
      container.read(trashedNotesProvider.notifier).add(dummyValue1);
      container.read(trashedNotesProvider.notifier).add(dummyValue2);

      // Act
      container.read(trashedNotesProvider.notifier).putBack(dummyValue1);

      // Verify
      final after = container.read(trashedNotesProvider);
      expect(after.length, 1);
      expect(after.contains(dummyValue1), isFalse);
      expect(after.contains(dummyValue2), isTrue);
    });
  });
}
