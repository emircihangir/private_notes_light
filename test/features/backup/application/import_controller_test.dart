import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:private_notes_light/features/authentication/domain/credentials_data.dart';
import 'package:private_notes_light/features/backup/application/file_picker_running.dart';
import 'package:private_notes_light/features/backup/application/file_picker_service.dart';
import 'package:private_notes_light/features/backup/application/import_controller.dart';
import 'package:private_notes_light/features/backup/data/backup_repository.dart';
import 'package:private_notes_light/features/backup/domain/backup_data.dart';
import 'package:private_notes_light/features/backup/domain/import_controller_state.dart';
import 'package:private_notes_light/features/encryption/application/encryption_service.dart';
import 'package:private_notes_light/features/encryption/application/master_key.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/settings/data/settings_repository.dart';
import 'package:private_notes_light/features/settings/domain/settings_data.dart';
import 'package:encrypt/encrypt.dart' as enc;

@GenerateNiceMocks([
  MockSpec<BackupRepository>(),
  MockSpec<EncryptionService>(),
  MockSpec<NoteRepository>(),
  MockSpec<FilePickerService>(),
  MockSpec<SettingsRepository>(),
])
import 'import_controller_test.mocks.dart';

void main() {
  late MockBackupRepository mockBackupRepo;
  late MockEncryptionService mockEncryptionService;
  late MockNoteRepository mockNoteRepo;
  late MockFilePickerService mockFilePickerService;
  late ProviderContainer container;

  setUp(() {
    mockBackupRepo = MockBackupRepository();
    mockEncryptionService = MockEncryptionService();
    mockNoteRepo = MockNoteRepository();
    mockFilePickerService = MockFilePickerService();

    container = ProviderContainer(
      overrides: [
        backupRepositoryProvider.overrideWith((_) => mockBackupRepo),
        noteRepositoryProvider.overrideWithValue(mockNoteRepo),
        encryptionServiceProvider.overrideWithValue(mockEncryptionService),
        filePickerServiceProvider.overrideWith((_) => mockFilePickerService),
      ],
    );
    addTearDown(container.dispose);
  });

  group('Import Controller Tests', () {
    group('startImport', () {
      test('startImport warns about overwrites', () async {
        // Set up
        when(mockNoteRepo.getNotes()).thenAnswer(
          (_) async => [
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
        await container
            .read(importControllerProvider.notifier)
            .startImport(dialogTitle: 'dialogTitle');

        // Verify
        expect(
          container
              .read(importControllerProvider)
              ?.maybeWhen(showOverwriteWarning: () => true, orElse: () => false),
          isTrue,
        );
      });

      test('startImport omits overwrite warning if there are no notes', () async {
        // Set up
        when(mockNoteRepo.getNotes()).thenAnswer((_) async => []);
        when(
          mockFilePickerService.pickFiles(dialogTitle: anyNamed('dialogTitle')),
        ).thenAnswer((_) async => null);

        // Act
        await container
            .read(importControllerProvider.notifier)
            .startImport(dialogTitle: 'dialogTitle');

        // Verify
        expect(container.read(importControllerProvider), isNull);
      });
    });
  });
}
