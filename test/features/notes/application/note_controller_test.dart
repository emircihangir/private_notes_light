import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:private_notes_light/features/backup/application/export_service.dart';
import 'package:private_notes_light/features/backup/data/backup_repository.dart';
import 'package:private_notes_light/features/encryption/application/encryption_service.dart';
import 'package:private_notes_light/features/encryption/application/master_key.dart';
import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/application/trashed_notes.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/note_controller_state.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/notes/domain/note_widget_data.dart';
import 'package:private_notes_light/features/notes/domain/trashed_note_data.dart';
import 'package:private_notes_light/features/settings/data/settings_repository.dart';
import 'package:private_notes_light/features/settings/domain/settings_data.dart';

@GenerateNiceMocks([
  MockSpec<NoteRepository>(),
  MockSpec<EncryptionService>(),
  MockSpec<SettingsRepository>(),
  MockSpec<BackupRepository>(),
])
import 'note_controller_test.mocks.dart';

void main() {
  late MockNoteRepository mockNoteRepo;
  late MockEncryptionService mockEncryptionService;
  late MockSettingsRepository mockSettingsRepo;
  late MockBackupRepository mockBackupRepo;
  late ProviderContainer container;

  setUp(() {
    mockNoteRepo = MockNoteRepository();
    mockEncryptionService = MockEncryptionService();
    mockSettingsRepo = MockSettingsRepository();
    mockBackupRepo = MockBackupRepository();

    container = container = ProviderContainer(
      overrides: [
        noteRepositoryProvider.overrideWith((ref) => mockNoteRepo),
        encryptionServiceProvider.overrideWith((ref) => mockEncryptionService),
        settingsRepositoryProvider.overrideWith((ref) => mockSettingsRepo),
        backupRepositoryProvider.overrideWith((ref) => mockBackupRepo),
      ],
    );
    addTearDown(container.dispose);
  });

  group('NoteController tests ->', () {
    group('triggerExport tests ->', () {
      test('shows success if export result is true', () async {
        // Setup
        final container = ProviderContainer(
          overrides: [
            noteRepositoryProvider.overrideWith((ref) => mockNoteRepo),
            exportServiceProvider.overrideWith((ref) async => true),
          ],
        );
        addTearDown(container.dispose);

        final dummyKey = enc.Key.fromLength(32);
        container.read(masterKeyProvider.notifier).set(dummyKey);

        // Act
        await container.read(noteControllerProvider.notifier).triggerExport();

        // Verify
        expect(container.read(noteControllerProvider).value!.showExportSuccessful, isTrue);
      });

      test('shows error if export result is false', () async {
        // Setup
        final container = ProviderContainer(
          overrides: [
            noteRepositoryProvider.overrideWith((ref) => mockNoteRepo),
            exportServiceProvider.overrideWith((ref) async => false),
          ],
        );
        addTearDown(container.dispose);

        final dummyKey = enc.Key.fromLength(32);
        container.read(masterKeyProvider.notifier).set(dummyKey);

        // Act
        await container.read(noteControllerProvider.notifier).triggerExport();

        // Verify
        expect(container.read(noteControllerProvider).value!.showError, isTrue);
        expect(
          container.read(noteControllerProvider).value!.errorKind,
          NoteErrorKind.failedToExport,
        );
      });
    });

    test('createNote works', () async {
      // Setup
      final dummyTitle = 'dummyTitle';
      final dummyContent = 'dummyContent';

      final dummyIv = enc.IV.fromLength(16);
      final dummyEncryptedText = 'encryptedText';
      when(
        mockEncryptionService.encryptWithMasterKey(dummyContent),
      ).thenReturn((encryptedText: dummyEncryptedText, encryptionIV: dummyIv));

      final dummyKey = enc.Key.fromLength(32);
      container.read(masterKeyProvider.notifier).set(dummyKey);

      var dummySettingsData = SettingsData(
        exportSuggestions: false,
        exportWarnings: false,
        theme: ThemeMode.system,
      );
      when(mockSettingsRepo.getSettings()).thenReturn(dummySettingsData);

      // Act
      await container
          .read(noteControllerProvider.notifier)
          .createNote(title: dummyTitle, content: dummyContent);

      // Verify
      verify(mockEncryptionService.encryptWithMasterKey(argThat(isA<String?>()))).called(1);
      verify(mockNoteRepo.addNote(argThat(isA<NoteDto>()))).called(1);
      verify(mockSettingsRepo.getSettings()).called(2);
    });

    group('suggestExportIfPreferred aligns with preference ->', () {
      test('suggests if true', () async {
        // Setup
        var dummySettingsData = SettingsData(
          exportSuggestions: true,
          exportWarnings: false,
          theme: ThemeMode.system,
        );
        when(mockSettingsRepo.getSettings()).thenReturn(dummySettingsData);

        final dummyKey = enc.Key.fromLength(32);
        container.read(masterKeyProvider.notifier).set(dummyKey);

        // Act
        await container.read(noteControllerProvider.notifier).suggestExportIfPreferred();

        // Verify
        final value = container.read(noteControllerProvider).value!.suggestExport;
        expect(value, isTrue);
        verify(mockSettingsRepo.getSettings()).called(1);
      });
      test('does not suggest if false', () async {
        // Setup
        var dummySettingsData = SettingsData(
          exportSuggestions: false,
          exportWarnings: false,
          theme: ThemeMode.system,
        );
        when(mockSettingsRepo.getSettings()).thenReturn(dummySettingsData);

        final dummyKey = enc.Key.fromLength(32);
        container.read(masterKeyProvider.notifier).set(dummyKey);

        // Act
        await container.read(noteControllerProvider.notifier).suggestExportIfPreferred();

        // Verify
        final value = container.read(noteControllerProvider).value!.suggestExport;
        expect(value, isFalse);
        verify(mockSettingsRepo.getSettings()).called(1);
      });
    });

    group('warnExportIfValid tests ->', () {
      test('warns if preferred and past seven days', () async {
        // Setup
        var dummySettingsData = SettingsData(
          exportSuggestions: false,
          exportWarnings: true,
          theme: ThemeMode.system,
        );
        when(mockSettingsRepo.getSettings()).thenReturn(dummySettingsData);

        final dummyLastExportDate = DateTime.now().add(Duration(days: -8));
        when(
          mockBackupRepo.getLastExportDate(),
        ).thenAnswer((realInvocation) async => dummyLastExportDate);

        final dummyKey = enc.Key.fromLength(32);
        container.read(masterKeyProvider.notifier).set(dummyKey);

        // Act
        await container.read(noteControllerProvider.notifier).warnExportIfValid();

        // Verify
        verify(mockSettingsRepo.getSettings()).called(1);
        verify(mockBackupRepo.getLastExportDate()).called(1);
        final value = container.read(noteControllerProvider).value!.warnExport;
        expect(value, isTrue);
      });
      test('does not warn if not preferred', () async {
        // Setup
        var dummySettingsData = SettingsData(
          exportSuggestions: false,
          exportWarnings: false,
          theme: ThemeMode.system,
        );
        when(mockSettingsRepo.getSettings()).thenReturn(dummySettingsData);

        final dummyKey = enc.Key.fromLength(32);
        container.read(masterKeyProvider.notifier).set(dummyKey);

        // Act
        await container.read(noteControllerProvider.notifier).warnExportIfValid();

        // Verify
        verify(mockSettingsRepo.getSettings()).called(1);
        verifyNever(mockBackupRepo.getLastExportDate());
        final value = container.read(noteControllerProvider).value!.warnExport;
        expect(value, isFalse);
      });
      test('does not warn if preferred but not past seven days', () async {
        // Setup
        var dummySettingsData = SettingsData(
          exportSuggestions: false,
          exportWarnings: true,
          theme: ThemeMode.system,
        );
        when(mockSettingsRepo.getSettings()).thenReturn(dummySettingsData);

        final dummyLastExportDate = DateTime.now().add(Duration(days: -4));
        when(
          mockBackupRepo.getLastExportDate(),
        ).thenAnswer((realInvocation) async => dummyLastExportDate);

        final dummyKey = enc.Key.fromLength(32);
        container.read(masterKeyProvider.notifier).set(dummyKey);

        // Act
        await container.read(noteControllerProvider.notifier).warnExportIfValid();

        // Verify
        verify(mockSettingsRepo.getSettings()).called(1);
        verify(mockBackupRepo.getLastExportDate()).called(1);
        final value = container.read(noteControllerProvider).value!.warnExport;
        expect(value, isFalse);
      });
    });

    test('moveNoteToTrash works', () {
      // Setup
      final noteToDelete = NoteWidgetData(noteId: 'note3', noteTitle: 'noteTitle');
      final List<NoteWidgetData> dummyData = [
        NoteWidgetData(noteId: 'note1', noteTitle: 'noteTitle'),
        NoteWidgetData(noteId: 'note2', noteTitle: 'noteTitle'),
        noteToDelete,
        NoteWidgetData(noteId: 'note4', noteTitle: 'noteTitle'),
      ];

      final dummyKey = enc.Key.fromLength(32);
      container.read(masterKeyProvider.notifier).set(dummyKey);

      container
          .read(noteControllerProvider.notifier)
          .setState(NoteControllerState(data: dummyData));

      // Act
      container.read(noteControllerProvider.notifier).moveNoteToTrash(noteToDelete);

      // Verify
      final trashedNotes = container.read(trashedNotesProvider);
      expect(trashedNotes.contains(TrashedNoteData(noteToDelete, 2)), isTrue);

      final newState = container.read(noteControllerProvider).value!;
      expect(newState.data.contains(noteToDelete), isFalse);
    });

    test('undoDelete works', () {
      // Setup
      final dummyKey = enc.Key.fromLength(32);
      container.read(masterKeyProvider.notifier).set(dummyKey);

      final List<NoteWidgetData> dummyData = [
        NoteWidgetData(noteId: 'note1', noteTitle: 'noteTitle'),
        NoteWidgetData(noteId: 'note2', noteTitle: 'noteTitle'),
        NoteWidgetData(noteId: 'note4', noteTitle: 'noteTitle'),
      ];
      container
          .read(noteControllerProvider.notifier)
          .setState(NoteControllerState(data: dummyData));

      final deletedNote1 = TrashedNoteData(
        NoteWidgetData(noteId: 'note3', noteTitle: 'noteTitle'),
        2,
      );
      final deletedNote2 = TrashedNoteData(
        NoteWidgetData(noteId: 'note5', noteTitle: 'noteTitle'),
        4,
      );
      container.read(trashedNotesProvider).add(deletedNote1);
      container.read(trashedNotesProvider).add(deletedNote2);

      // Act
      container.read(noteControllerProvider.notifier).undoDelete();

      // Verify
      var trashedNotes = container.read(trashedNotesProvider);
      expect(trashedNotes.contains(deletedNote2), isFalse);
      expect(trashedNotes.contains(deletedNote1), isTrue);
      expect(trashedNotes.length, 1);

      var currentNotesList = container.read(noteControllerProvider).valueOrNull!.data;
      expect(currentNotesList.contains(deletedNote2.noteWidgetData), isTrue);

      // Act
      container.read(noteControllerProvider.notifier).undoDelete();

      // Verify
      trashedNotes = container.read(trashedNotesProvider);
      expect(trashedNotes.contains(deletedNote2), isFalse);
      expect(trashedNotes.contains(deletedNote1), isFalse);
      expect(trashedNotes.isEmpty, isTrue);

      currentNotesList = container.read(noteControllerProvider).valueOrNull!.data;
      expect(currentNotesList.contains(deletedNote2.noteWidgetData), isTrue);
      expect(currentNotesList.contains(deletedNote1.noteWidgetData), isTrue);
    });

    test('putNoteBack works', () {
      // Setup
      final dummyKey = enc.Key.fromLength(32);
      container.read(masterKeyProvider.notifier).set(dummyKey);

      final List<NoteWidgetData> dummyData = [
        NoteWidgetData(noteId: 'note1', noteTitle: 'noteTitle'),
        NoteWidgetData(noteId: 'note2', noteTitle: 'noteTitle'),
        NoteWidgetData(noteId: 'note4', noteTitle: 'noteTitle'),
      ];
      container
          .read(noteControllerProvider.notifier)
          .setState(NoteControllerState(data: dummyData));

      final deletedNote1 = TrashedNoteData(
        NoteWidgetData(noteId: 'note3', noteTitle: 'noteTitle'),
        2,
      );
      final deletedNote2 = TrashedNoteData(
        NoteWidgetData(noteId: 'note5', noteTitle: 'noteTitle'),
        4,
      );
      container.read(trashedNotesProvider).add(deletedNote1);
      container.read(trashedNotesProvider).add(deletedNote2);

      // Act
      container.read(noteControllerProvider.notifier).putNoteBack(deletedNote1);

      // Verify
      var trashedNotes = container.read(trashedNotesProvider);
      expect(trashedNotes.contains(deletedNote2), isTrue);
      expect(trashedNotes.contains(deletedNote1), isFalse);
      expect(trashedNotes.length, 1);

      var currentNotesList = container.read(noteControllerProvider).valueOrNull!.data;
      expect(currentNotesList.contains(deletedNote1.noteWidgetData), isTrue);

      // Act
      container.read(noteControllerProvider.notifier).putNoteBack(deletedNote2);

      // Verify
      trashedNotes = container.read(trashedNotesProvider);
      expect(trashedNotes.contains(deletedNote2), isFalse);
      expect(trashedNotes.contains(deletedNote1), isFalse);
      expect(trashedNotes.isEmpty, isTrue);

      currentNotesList = container.read(noteControllerProvider).valueOrNull!.data;
      expect(currentNotesList.contains(deletedNote1.noteWidgetData), isTrue);
      expect(currentNotesList.contains(deletedNote2.noteWidgetData), isTrue);
    });

  });
}
