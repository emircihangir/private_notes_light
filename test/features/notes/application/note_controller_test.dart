import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:private_notes_light/features/authentication/application/auth_service.dart';
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
  MockSpec<AuthService>(),
])
import 'note_controller_test.mocks.dart';

void main() {
  late MockNoteRepository mockNoteRepo;
  late MockEncryptionService mockEncryptionService;
  late MockSettingsRepository mockSettingsRepo;
  late MockBackupRepository mockBackupRepo;
  late MockAuthService mockAuthService;
  late ProviderContainer container;

  Future<void> initNoteController() async {
    final sub = container.listen(noteControllerProvider, (previous, next) {});
    addTearDown(sub.close);

    await container.read(noteControllerProvider.future);
  }

  setUp(() {
    mockNoteRepo = MockNoteRepository();
    mockEncryptionService = MockEncryptionService();
    mockSettingsRepo = MockSettingsRepository();
    mockBackupRepo = MockBackupRepository();
    mockAuthService = MockAuthService();

    container = ProviderContainer(
      overrides: [
        noteRepositoryProvider.overrideWith((ref) => mockNoteRepo),
        encryptionServiceProvider.overrideWith((ref) => mockEncryptionService),
        settingsRepositoryProvider.overrideWith((ref) => mockSettingsRepo),
        backupRepositoryProvider.overrideWith((ref) => mockBackupRepo),
        authServiceProvider.overrideWith((ref) => mockAuthService),
      ],
    );
    addTearDown(container.dispose);
  });

  group('NoteController tests ->', () {
    test('build loads note widget data from repository dtos', () async {
      // Setup
      final dummyKey = enc.Key.fromLength(32);
      container.read(masterKeyProvider.notifier).set(dummyKey);

      final dummySettingsData = SettingsData(exportSuggestions: false, exportWarnings: false, theme: ThemeMode.system);
      when(mockSettingsRepo.getSettings()).thenReturn(dummySettingsData);
      when(mockNoteRepo.getNotes()).thenAnswer(
        (_) async => [
          NoteDto(
            id: 'note1',
            title: 'First note',
            content: 'content1',
            iv: enc.IV.fromLength(16).base64,
            dateCreated: DateTime(2024).toIso8601String(),
          ),
          NoteDto(
            id: 'note2',
            title: 'Second note',
            content: 'content2',
            iv: enc.IV.fromLength(16).base64,
            dateCreated: DateTime(2025).toIso8601String(),
          ),
        ],
      );

      // Act
      await initNoteController();

      // Verify
      expect(container.read(noteControllerProvider).value!.data, [
        const NoteWidgetData(noteId: 'note1', noteTitle: 'First note'),
        const NoteWidgetData(noteId: 'note2', noteTitle: 'Second note'),
      ]);
    });

    group('triggerExport tests ->', () {
      test('shows success if export result is true', () async {
        // Setup
        final container = ProviderContainer(
          overrides: [noteRepositoryProvider.overrideWith((ref) => mockNoteRepo), exportServiceProvider.overrideWith((ref) async => true)],
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
          overrides: [noteRepositoryProvider.overrideWith((ref) => mockNoteRepo), exportServiceProvider.overrideWith((ref) async => false)],
        );
        addTearDown(container.dispose);

        final dummyKey = enc.Key.fromLength(32);
        container.read(masterKeyProvider.notifier).set(dummyKey);

        // Act
        await container.read(noteControllerProvider.notifier).triggerExport();

        // Verify
        expect(container.read(noteControllerProvider).value!.showError, isTrue);
        expect(container.read(noteControllerProvider).value!.errorKind, NoteErrorKind.failedToExport);
      });
    });

    test('createNote works', () async {
      // Setup
      final dummyTitle = 'dummyTitle';
      final dummyContent = 'dummyContent';

      final dummyIv = enc.IV.fromLength(16);
      final dummyEncryptedText = 'encryptedText';
      when(mockEncryptionService.encryptWithMasterKey(dummyContent)).thenReturn((encryptedText: dummyEncryptedText, encryptionIV: dummyIv));

      final dummyKey = enc.Key.fromLength(32);
      container.read(masterKeyProvider.notifier).set(dummyKey);

      var dummySettingsData = SettingsData(exportSuggestions: false, exportWarnings: false, theme: ThemeMode.system);
      when(mockSettingsRepo.getSettings()).thenReturn(dummySettingsData);

      await initNoteController();
      clearInteractions(mockSettingsRepo);

      // Act
      await container.read(noteControllerProvider.notifier).createNote(title: dummyTitle, content: dummyContent);

      // Verify
      verify(mockEncryptionService.encryptWithMasterKey(argThat(isA<String?>()))).called(1);
      verify(mockNoteRepo.addNote(argThat(isA<NoteDto>()))).called(1);
      verify(mockSettingsRepo.getSettings()).called(2);
    });

    test('createNote persists encrypted dto with provided id and date', () async {
      // Setup
      final dummyData = (
        id: 'note-id',
        title: 'dummyTitle',
        content: 'dummyContent',
        encryptedText: 'encryptedText',
        date: DateTime(2024, 2, 3, 4, 5),
        iv: enc.IV.fromLength(16),
      );
      when(
        mockEncryptionService.encryptWithMasterKey(dummyData.content),
      ).thenReturn((encryptedText: dummyData.encryptedText, encryptionIV: dummyData.iv));

      final dummyKey = enc.Key.fromLength(32);
      container.read(masterKeyProvider.notifier).set(dummyKey);

      var dummySettingsData = SettingsData(exportSuggestions: false, exportWarnings: false, theme: ThemeMode.system);
      when(mockSettingsRepo.getSettings()).thenReturn(dummySettingsData);

      await initNoteController();

      // Act
      await container
          .read(noteControllerProvider.notifier)
          .createNote(id: dummyData.id, title: dummyData.title, content: dummyData.content, date: dummyData.date);

      // Verify
      final capturedDto = verify(mockNoteRepo.addNote(captureAny)).captured.single as NoteDto;
      expect(capturedDto.id, dummyData.id);
      expect(capturedDto.title, dummyData.title);
      expect(capturedDto.content, dummyData.encryptedText);
      expect(capturedDto.iv, dummyData.iv.base64);
      expect(capturedDto.dateCreated, dummyData.date.toIso8601String());
    });

    group('suggestExportIfPreferred aligns with preference ->', () {
      test('suggests if true', () async {
        // Setup
        var dummySettingsData = SettingsData(exportSuggestions: true, exportWarnings: false, theme: ThemeMode.system);
        when(mockSettingsRepo.getSettings()).thenReturn(dummySettingsData);

        final dummyKey = enc.Key.fromLength(32);
        container.read(masterKeyProvider.notifier).set(dummyKey);

        await initNoteController();
        clearInteractions(mockSettingsRepo);

        // Act
        await container.read(noteControllerProvider.notifier).suggestExportIfPreferred();

        // Verify
        final value = container.read(noteControllerProvider).value!.suggestExport;
        expect(value, isTrue);
      });
      test('does not suggest if false', () async {
        // Setup
        var dummySettingsData = SettingsData(exportSuggestions: false, exportWarnings: false, theme: ThemeMode.system);
        when(mockSettingsRepo.getSettings()).thenReturn(dummySettingsData);

        final dummyKey = enc.Key.fromLength(32);
        container.read(masterKeyProvider.notifier).set(dummyKey);

        await initNoteController();
        clearInteractions(mockSettingsRepo);

        // Act
        await container.read(noteControllerProvider.notifier).suggestExportIfPreferred();

        // Verify
        final value = container.read(noteControllerProvider).value!.suggestExport;
        expect(value, isFalse);
      });
    });

    group('warnExportIfValid tests ->', () {
      test('warns if preferred and past seven days', () async {
        // Setup
        var dummySettingsData = SettingsData(exportSuggestions: false, exportWarnings: true, theme: ThemeMode.system);
        when(mockSettingsRepo.getSettings()).thenReturn(dummySettingsData);

        final dummyLastExportDate = DateTime.now().add(const Duration(days: -8));
        when(mockBackupRepo.getLastExportDate()).thenAnswer((realInvocation) async => dummyLastExportDate);

        final dummyKey = enc.Key.fromLength(32);
        container.read(masterKeyProvider.notifier).set(dummyKey);

        await initNoteController();

        // Act
        await container.read(noteControllerProvider.notifier).warnExportIfValid();

        // Verify
        final value = container.read(noteControllerProvider).value!.warnExport;
        expect(value, isTrue);
      });
      test('does not warn if not preferred', () async {
        // Setup
        var dummySettingsData = SettingsData(exportSuggestions: false, exportWarnings: false, theme: ThemeMode.system);
        when(mockSettingsRepo.getSettings()).thenReturn(dummySettingsData);

        final dummyKey = enc.Key.fromLength(32);
        container.read(masterKeyProvider.notifier).set(dummyKey);

        await initNoteController();

        // Act
        await container.read(noteControllerProvider.notifier).warnExportIfValid();

        // Verify
        final value = container.read(noteControllerProvider).value!.warnExport;
        expect(value, isFalse);
        verifyNever(mockBackupRepo.getLastExportDate());
      });
      test('does not warn if preferred but not past seven days', () async {
        // Setup
        var dummySettingsData = SettingsData(exportSuggestions: false, exportWarnings: true, theme: ThemeMode.system);
        when(mockSettingsRepo.getSettings()).thenReturn(dummySettingsData);

        final dummyLastExportDate = DateTime.now().add(const Duration(days: -4));
        when(mockBackupRepo.getLastExportDate()).thenAnswer((realInvocation) async => dummyLastExportDate);

        final dummyKey = enc.Key.fromLength(32);
        container.read(masterKeyProvider.notifier).set(dummyKey);

        await initNoteController();

        // Act
        await container.read(noteControllerProvider.notifier).warnExportIfValid();

        // Verify
        final value = container.read(noteControllerProvider).value!.warnExport;
        expect(value, isFalse);
      });
      test('does not warn if there is no last export date', () async {
        // Setup
        var dummySettingsData = SettingsData(exportSuggestions: false, exportWarnings: true, theme: ThemeMode.system);
        when(mockSettingsRepo.getSettings()).thenReturn(dummySettingsData);
        when(mockBackupRepo.getLastExportDate()).thenAnswer((_) async => null);

        final dummyKey = enc.Key.fromLength(32);
        container.read(masterKeyProvider.notifier).set(dummyKey);

        await initNoteController();

        // Act
        await container.read(noteControllerProvider.notifier).warnExportIfValid();

        // Verify
        final value = container.read(noteControllerProvider).value!.warnExport;
        expect(value, isFalse);
        verify(mockBackupRepo.getLastExportDate()).called(1);
      });
    });

    test('moveNoteToTrash works', () {
      // Setup
      final noteToDelete = const NoteWidgetData(noteId: 'note3', noteTitle: 'noteTitle');
      final List<NoteWidgetData> dummyData = [
        const NoteWidgetData(noteId: 'note1', noteTitle: 'noteTitle'),
        const NoteWidgetData(noteId: 'note2', noteTitle: 'noteTitle'),
        noteToDelete,
        const NoteWidgetData(noteId: 'note4', noteTitle: 'noteTitle'),
      ];

      final dummyKey = enc.Key.fromLength(32);
      container.read(masterKeyProvider.notifier).set(dummyKey);

      container.read(noteControllerProvider.notifier).setState(NoteControllerState(data: dummyData));

      // Act
      container.read(noteControllerProvider.notifier).moveNoteToTrash(noteToDelete);

      // Verify
      final trashedNotes = container.read(trashedNotesProvider);
      expect(trashedNotes.contains(TrashedNoteData(noteToDelete, 2)), isTrue);

      final newState = container.read(noteControllerProvider).value!;
      expect(newState.data.contains(noteToDelete), isFalse);
      expect(newState.showInfo, isTrue);
      expect(newState.infoKind, InfoKind.noteDeleted);
    });

    test('undoDelete works', () {
      // Setup
      final dummyKey = enc.Key.fromLength(32);
      container.read(masterKeyProvider.notifier).set(dummyKey);

      final List<NoteWidgetData> dummyData = [
        const NoteWidgetData(noteId: 'note1', noteTitle: 'noteTitle'),
        const NoteWidgetData(noteId: 'note2', noteTitle: 'noteTitle'),
        const NoteWidgetData(noteId: 'note4', noteTitle: 'noteTitle'),
      ];
      container.read(noteControllerProvider.notifier).setState(NoteControllerState(data: dummyData));

      final deletedNote1 = const TrashedNoteData(NoteWidgetData(noteId: 'note3', noteTitle: 'noteTitle'), 2);
      final deletedNote2 = const TrashedNoteData(NoteWidgetData(noteId: 'note5', noteTitle: 'noteTitle'), 4);
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
      expect(currentNotesList, [
        const NoteWidgetData(noteId: 'note1', noteTitle: 'noteTitle'),
        const NoteWidgetData(noteId: 'note2', noteTitle: 'noteTitle'),
        const NoteWidgetData(noteId: 'note4', noteTitle: 'noteTitle'),
        deletedNote2.noteWidgetData,
      ]);

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
      expect(currentNotesList, [
        const NoteWidgetData(noteId: 'note1', noteTitle: 'noteTitle'),
        const NoteWidgetData(noteId: 'note2', noteTitle: 'noteTitle'),
        deletedNote1.noteWidgetData,
        const NoteWidgetData(noteId: 'note4', noteTitle: 'noteTitle'),
        deletedNote2.noteWidgetData,
      ]);
    });

    test('putNoteBack works', () {
      // Setup
      final dummyKey = enc.Key.fromLength(32);
      container.read(masterKeyProvider.notifier).set(dummyKey);

      final List<NoteWidgetData> dummyData = [
        const NoteWidgetData(noteId: 'note1', noteTitle: 'noteTitle'),
        const NoteWidgetData(noteId: 'note2', noteTitle: 'noteTitle'),
        const NoteWidgetData(noteId: 'note4', noteTitle: 'noteTitle'),
      ];
      container.read(noteControllerProvider.notifier).setState(NoteControllerState(data: dummyData));

      final deletedNote1 = const TrashedNoteData(NoteWidgetData(noteId: 'note3', noteTitle: 'noteTitle'), 2);
      final deletedNote2 = const TrashedNoteData(NoteWidgetData(noteId: 'note5', noteTitle: 'noteTitle'), 4);
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
      expect(currentNotesList, [
        const NoteWidgetData(noteId: 'note1', noteTitle: 'noteTitle'),
        const NoteWidgetData(noteId: 'note2', noteTitle: 'noteTitle'),
        deletedNote1.noteWidgetData,
        const NoteWidgetData(noteId: 'note4', noteTitle: 'noteTitle'),
      ]);

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
      expect(currentNotesList, [
        const NoteWidgetData(noteId: 'note1', noteTitle: 'noteTitle'),
        const NoteWidgetData(noteId: 'note2', noteTitle: 'noteTitle'),
        deletedNote1.noteWidgetData,
        const NoteWidgetData(noteId: 'note4', noteTitle: 'noteTitle'),
        deletedNote2.noteWidgetData,
      ]);
    });

    group('logout tests ->', () {
      test('empties the trash', () async {
        // Setup
        final dummyKey = enc.Key.fromLength(32);
        container.read(masterKeyProvider.notifier).set(dummyKey);

        final List<NoteWidgetData> dummyData = [
          const NoteWidgetData(noteId: 'note1', noteTitle: 'noteTitle'),
          const NoteWidgetData(noteId: 'note2', noteTitle: 'noteTitle'),
          const NoteWidgetData(noteId: 'note4', noteTitle: 'noteTitle'),
        ];
        container.read(noteControllerProvider.notifier).setState(NoteControllerState(data: dummyData));

        final deletedNote1 = const TrashedNoteData(NoteWidgetData(noteId: 'note3', noteTitle: 'noteTitle'), 2);
        final deletedNote2 = const TrashedNoteData(NoteWidgetData(noteId: 'note5', noteTitle: 'noteTitle'), 4);
        container.read(trashedNotesProvider).add(deletedNote1);
        container.read(trashedNotesProvider).add(deletedNote2);

        await initNoteController();

        // Act
        await container.read(noteControllerProvider.notifier).logout();

        // Verify
        var trashedNotes = container.read(trashedNotesProvider);
        expect(trashedNotes.isEmpty, isTrue);
      });

      test('calls authServiceProvider.logout()', () async {
        // Setup
        final dummyKey = enc.Key.fromLength(32);
        container.read(masterKeyProvider.notifier).set(dummyKey);

        final List<NoteWidgetData> dummyData = [
          const NoteWidgetData(noteId: 'note1', noteTitle: 'noteTitle'),
          const NoteWidgetData(noteId: 'note2', noteTitle: 'noteTitle'),
          const NoteWidgetData(noteId: 'note4', noteTitle: 'noteTitle'),
        ];
        container.read(noteControllerProvider.notifier).setState(NoteControllerState(data: dummyData));

        final deletedNote1 = const TrashedNoteData(NoteWidgetData(noteId: 'note3', noteTitle: 'noteTitle'), 2);
        final deletedNote2 = const TrashedNoteData(NoteWidgetData(noteId: 'note5', noteTitle: 'noteTitle'), 4);
        container.read(trashedNotesProvider).add(deletedNote1);
        container.read(trashedNotesProvider).add(deletedNote2);

        await initNoteController();

        // Act
        await container.read(noteControllerProvider.notifier).logout();

        // Verify
        verify(mockAuthService.logout()).called(1);
      });
    });

    test('openNote works', () async {
      // Setup
      final dummyData = (
        key: enc.Key.fromLength(32),
        noteId: 'noteId',
        iv: enc.IV.fromLength(16),
        date: DateTime.now().toIso8601String(),
        encryptedContent: 'encryptedContent',
        decryptedContent: 'decryptedContent',
      );
      container.read(masterKeyProvider.notifier).set(dummyData.key);
      when(mockNoteRepo.getNote(dummyData.noteId)).thenAnswer(
        (_) async =>
            NoteDto(id: dummyData.noteId, title: 'title', content: dummyData.encryptedContent, iv: dummyData.iv.base64, dateCreated: dummyData.date),
      );
      when(mockEncryptionService.decryptWithMasterKey(dummyData.encryptedContent, dummyData.iv)).thenReturn(dummyData.decryptedContent);

      await initNoteController();

      // Act
      final openedNote = await container.read(noteControllerProvider.notifier).openNote(dummyData.noteId);

      // Verify
      expect(openedNote.content, dummyData.decryptedContent);
    });

    test('openNote throws when note does not exist', () async {
      // Setup
      const missingNoteId = 'missing-note-id';
      final dummyKey = enc.Key.fromLength(32);
      container.read(masterKeyProvider.notifier).set(dummyKey);
      when(mockNoteRepo.getNote(missingNoteId)).thenAnswer((_) async => null);

      await initNoteController();

      // Act & Verify
      expect(() => container.read(noteControllerProvider.notifier).openNote(missingNoteId), throwsA(isA<Exception>()));
    });

    test('consume methods clear transient flags', () {
      // Setup
      final dummyKey = enc.Key.fromLength(32);
      container.read(masterKeyProvider.notifier).set(dummyKey);

      container
          .read(noteControllerProvider.notifier)
          .setState(
            const NoteControllerState(
              showError: true,
              errorKind: NoteErrorKind.failedToExport,
              suggestExport: true,
              warnExport: true,
              showExportSuccessful: true,
              showInfo: true,
              infoKind: InfoKind.noteDeleted,
            ),
          );

      // Act
      final notifier = container.read(noteControllerProvider.notifier);
      notifier.consumeExportWarning();
      notifier.consumeExportSuggestion();
      notifier.consumeInfoSnackbar();
      notifier.consumeError();
      notifier.consumeExportSuccess();

      // Verify
      final newState = container.read(noteControllerProvider).value!;
      expect(newState.warnExport, isFalse);
      expect(newState.suggestExport, isFalse);
      expect(newState.showInfo, isFalse);
      expect(newState.infoKind, isNull);
      expect(newState.showError, isFalse);
      expect(newState.errorKind, isNull);
      expect(newState.showExportSuccessful, isFalse);
    });
  });
}
