import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:private_notes_light/features/authentication/data/auth_repository.dart';
import 'package:private_notes_light/features/authentication/domain/credentials_data.dart';
import 'package:private_notes_light/features/backup/application/export_service.dart';
import 'package:private_notes_light/features/backup/application/file_picker_running.dart';
import 'package:private_notes_light/features/backup/data/backup_repository.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/settings/data/settings_repository.dart';
import 'package:private_notes_light/features/settings/domain/settings_data.dart';

@GenerateNiceMocks([
  MockSpec<BackupRepository>(),
  MockSpec<AuthRepository>(),
  MockSpec<NoteRepository>(),
  MockSpec<SettingsRepository>(),
])
import 'export_service_test.mocks.dart';

void main() {
  late MockBackupRepository mockBackupRepository;
  late MockAuthRepository mockAuthRepository;
  late MockNoteRepository mockNoteRepository;
  late MockSettingsRepository mockSettingsRepository;
  late ProviderContainer container;

  setUp(() {
    mockBackupRepository = MockBackupRepository();
    mockAuthRepository = MockAuthRepository();
    mockNoteRepository = MockNoteRepository();
    mockSettingsRepository = MockSettingsRepository();

    container = ProviderContainer(
      overrides: [
        backupRepositoryProvider.overrideWith((ref) async => mockBackupRepository),
        authRepositoryProvider.overrideWith((_) => mockAuthRepository),
        noteRepositoryProvider.overrideWith((_) => mockNoteRepository),
        settingsRepositoryProvider.overrideWith((ref) async => mockSettingsRepository),
      ],
    );
    addTearDown(container.dispose);

    final dummyCredentials = CredentialsData(
      salt: 'salt',
      iv: 'iv',
      encryptedMasterKey: 'encryptedMasterKey',
    );
    final dummySettings = SettingsData(
      exportSuggestions: true,
      exportWarnings: true,
      theme: ThemeMode.system,
    );
    final List<NoteDto> dummyNotes = [
      NoteDto(id: 'id', title: 'title', content: 'content', iv: 'iv', dateCreated: 'dateCreated'),
    ];
    when(mockAuthRepository.readCredentials()).thenAnswer((_) async => dummyCredentials);
    when(mockSettingsRepository.getSettings()).thenReturn(dummySettings);
    when(mockNoteRepository.getNotes()).thenAnswer((_) async => dummyNotes);
  });

  group('exportService aligns with backupRepository', () {
    test('both return true', () async {
      // Setup
      when(mockBackupRepository.export(any)).thenAnswer((_) async => true);

      // Act
      final result = await container.read(exportServiceProvider.future);

      // Verify
      expect(result, isTrue);
    });

    test('both return false', () async {
      // Setup
      when(mockBackupRepository.export(any)).thenAnswer((_) async => false);

      final List<bool> filePickerRunningValueHistory = [];
      container.listen(filePickerRunningProvider, (previous, next) {
        filePickerRunningValueHistory.add(next);
      });

      // Act
      final result = await container.read(exportServiceProvider.future);

      // Verify
      expect(result, isFalse);
      expect(filePickerRunningValueHistory, [true, false]);
    });
  });

  test('exportService correctly modifies filePickerRunningProvider', () async {
    // Setup
    when(mockBackupRepository.export(any)).thenAnswer((_) async => true);
    final List<bool> filePickerRunningValueHistory = [];
    container.listen(filePickerRunningProvider, (previous, next) {
      filePickerRunningValueHistory.add(next);
    });

    // Act
    await container.read(exportServiceProvider.future);

    // Verify
    expect(filePickerRunningValueHistory, [true, false]);
  });
}
