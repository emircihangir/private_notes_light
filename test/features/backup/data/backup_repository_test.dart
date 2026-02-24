import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:private_notes_light/features/authentication/domain/credentials_data.dart';
import 'package:private_notes_light/features/backup/application/file_picker_service.dart';
import 'package:private_notes_light/features/backup/application/path_service.dart';
import 'package:private_notes_light/features/backup/data/backup_repository.dart';
import 'package:private_notes_light/features/backup/domain/backup_data.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/settings/domain/settings_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/dummy_backup_data.dart';

@GenerateNiceMocks([MockSpec<PathService>(), MockSpec<FilePickerService>()])
import 'backup_repository_test.mocks.dart';

void main() {
  late MockPathService mockPathService;
  late MockFilePickerService mockFilePickerService;
  late ProviderContainer container;

  setUp(() {
    mockPathService = MockPathService();
    mockFilePickerService = MockFilePickerService();
    container = ProviderContainer(
      overrides: [
        pathServiceProvider.overrideWith((ref) => mockPathService),
        filePickerServiceProvider.overrideWith((ref) => mockFilePickerService),
      ],
    );
    addTearDown(container.dispose);
  });

  group('export works', () {
    test('returns true and sets last export date if export is successful', () async {
      // Setup
      when(
        mockFilePickerService.saveFile(
          fileName: argThat(isA<String?>(), named: 'fileName'),
          dialogTitle: argThat(isA<String?>(), named: 'dialogTitle'),
          bytes: argThat(isA<Uint8List?>(), named: 'bytes'),
        ),
      ).thenAnswer((realInvocation) async => 'dummyAnswer');
      when(
        mockPathService.getTempDirectory(),
      ).thenAnswer((realInvocation) async => Directory.systemTemp);

      SharedPreferences.setMockInitialValues({});

      final dummyBackupData = BackupData(
        credentialsData: CredentialsData(
          salt: 'salt',
          iv: 'iviv',
          encryptedMasterKey: 'encryptedMasterKey',
        ),
        settingsData: SettingsData(
          exportSuggestions: true,
          exportWarnings: true,
          theme: ThemeMode.system,
        ),
        notesData: [
          NoteDto(
            id: 'id',
            title: 'title',
            content: 'content',
            iv: 'iv',
            dateCreated: 'dateCreated',
          ),
        ],
      );

      // Act
      final backupRepository = await container.read(backupRepositoryProvider.future);
      final exportResult = await backupRepository.export(dummyBackupData.toJson());

      // Verify
      final prefs = await SharedPreferences.getInstance();
      verify(
        mockFilePickerService.saveFile(
          fileName: argThat(isA<String?>(), named: 'fileName'),
          dialogTitle: argThat(isA<String?>(), named: 'dialogTitle'),
          bytes: argThat(isA<Uint8List?>(), named: 'bytes'),
        ),
      ).called(1);
      expect(prefs.getString(BackupRepository.lastExportDateKey), isNotNull);
      expect(exportResult, true);
    });

    test('returns false and does not set last export date if export is unsuccessful', () async {
      // Setup
      when(
        mockFilePickerService.saveFile(
          fileName: argThat(isA<String?>(), named: 'fileName'),
          dialogTitle: argThat(isA<String?>(), named: 'dialogTitle'),
          bytes: argThat(isA<Uint8List?>(), named: 'bytes'),
        ),
      ).thenAnswer((realInvocation) async => null);
      when(
        mockPathService.getTempDirectory(),
      ).thenAnswer((realInvocation) async => Directory.systemTemp);
      SharedPreferences.setMockInitialValues({});

      // Act
      final backupRepository = await container.read(backupRepositoryProvider.future);
      final exportResult = await backupRepository.export(dummyBackupData().toJson());

      // Verify
      final prefs = await SharedPreferences.getInstance();
      verify(
        mockFilePickerService.saveFile(
          fileName: argThat(isA<String?>(), named: 'fileName'),
          dialogTitle: argThat(isA<String?>(), named: 'dialogTitle'),
          bytes: argThat(isA<Uint8List?>(), named: 'bytes'),
        ),
      ).called(1);
      expect(prefs.getString(BackupRepository.lastExportDateKey), isNull);
      expect(exportResult, false);
    });
  });
}
