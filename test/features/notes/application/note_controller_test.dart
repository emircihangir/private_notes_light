import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:private_notes_light/features/backup/application/export_service.dart';
import 'package:private_notes_light/features/encryption/application/encryption_service.dart';
import 'package:private_notes_light/features/encryption/application/master_key.dart';
import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/note_controller_state.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/settings/data/settings_repository.dart';
import 'package:private_notes_light/features/settings/domain/settings_data.dart';

@GenerateNiceMocks([
  MockSpec<NoteRepository>(),
  MockSpec<EncryptionService>(),
  MockSpec<SettingsRepository>(),
])
import 'note_controller_test.mocks.dart';

void main() {
  late MockNoteRepository mockNoteRepo;
  late MockEncryptionService mockEncryptionService;
  late MockSettingsRepository mockSettingsRepo;
  late ProviderContainer container;

  setUp(() {
    mockNoteRepo = MockNoteRepository();
    mockEncryptionService = MockEncryptionService();
    mockSettingsRepo = MockSettingsRepository();

    container = container = ProviderContainer(
      overrides: [
        noteRepositoryProvider.overrideWith((ref) => mockNoteRepo),
        encryptionServiceProvider.overrideWith((ref) => mockEncryptionService),
        settingsRepositoryProvider.overrideWith((ref) => mockSettingsRepo),
      ],
    );
    addTearDown(container.dispose);
  });

  group('triggerExport works', () {
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
      expect(container.read(noteControllerProvider).value!.errorKind, NoteErrorKind.failedToExport);
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

  group('suggestExportIfPreferred aligns with preference', () {
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
}
