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
    group('startImport works', () {
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

    test('showFilePicker works', () async {
      // Set up
      when(
        mockFilePickerService.pickFiles(dialogTitle: anyNamed('dialogTitle')),
      ).thenAnswer((_) async => null);
      final List<bool> valueHistory = [];
      container.listen(filePickerRunningProvider, (previous, next) => valueHistory.add(next));

      // Act
      await container
          .read(importControllerProvider.notifier)
          .showFilePicker(dialogTitle: 'dialogTitle');

      // Verify
      expect(valueHistory, [true, false]);
    });

    group('validateImportFile works', () {
      test('Disallows non-JSON files.', () async {
        // Set up
        final tempDir = Directory.systemTemp;
        final dummyFile = File('${tempDir.path}/dummy.png');
        final invalidBytes = [0xFF, 0xFE, 0xFD];
        await dummyFile.writeAsBytes(invalidBytes);
        PlatformFile dummyPlatformFile = PlatformFile(
          name: 'dummy.png',
          size: await dummyFile.length(),
          bytes: await dummyFile.readAsBytes(),
          path: dummyFile.path,
        );
        container.listen(importControllerProvider, (previous, next) {});

        // Act
        await container
            .read(importControllerProvider.notifier)
            .validateImportFile(dummyPlatformFile);

        // Verify
        final controllerState = container.read(importControllerProvider);
        expect(
          controllerState?.maybeWhen(showError: (errorKind) => errorKind, orElse: () => null),
          ImportErrorKind.invalidFileType,
        );
      });

      test('Detects invalid JSON syntax.', () async {
        // Set up
        final tempDir = Directory.systemTemp;
        final dummyFile = File('${tempDir.path}/dummyFile.json');
        final invalidJsonContent = "{someinvalidKey : someInvalidValue}";
        await dummyFile.writeAsString(invalidJsonContent);
        PlatformFile dummyPlatformFile = PlatformFile(
          name: 'dummyFile.json',
          size: await dummyFile.length(),
          bytes: await dummyFile.readAsBytes(),
          path: dummyFile.path,
        );
        container.listen(importControllerProvider, (previous, next) {});

        // Act
        await container
            .read(importControllerProvider.notifier)
            .validateImportFile(dummyPlatformFile);

        // Verify
        expect(
          container
              .read(importControllerProvider)
              ?.maybeWhen(showError: (errorKind) => errorKind, orElse: () => null),
          ImportErrorKind.couldNotParseJson,
        );
      });

      test('Detects corrupt file data.', () async {
        // Set up
        final tempDir = Directory.systemTemp;
        final dummyFile = File('${tempDir.path}/dummyFile.json');
        final invalidContent =
            '{"asdasdasd":{"salt":"-ffh_zaHtWAMXxMi39vU2w==","i":"1dN0Z0FeAcw5XyTNr3A3Xw==","encrypteasterKey":"Qzl95zRzDvjoz9JlvQ5bXShmXNc1XyKcE/nlNlaLIS83BopBUkDBL6wkylNOSkUW"},"qweqewqwe":{"exportSuggestions":true,"exportWarnings":true,"theme":"system"},"3eho1uhe1e":[{"id":"70e0c1e0-a912-44d6-9990-0a8a65c9fa10","title":"asdasda","content":"7r7ShtHFMEjh6vVNsKBYsw==","iv":"BlT181v8X28rFOIt6qPibQ==","dateCreated":"2026-02-13T15:24:29.538453"}]}';
        await dummyFile.writeAsString(invalidContent);
        PlatformFile dummyPlatformFile = PlatformFile(
          name: 'dummyFile.json',
          size: await dummyFile.length(),
          bytes: await dummyFile.readAsBytes(),
          path: dummyFile.path,
        );
        container.listen(importControllerProvider, (previous, next) {});

        // Act
        await container
            .read(importControllerProvider.notifier)
            .validateImportFile(dummyPlatformFile);

        // Verify
        expect(
          container
              .read(importControllerProvider)
              ?.maybeWhen(showError: (errorKind) => errorKind, orElse: () => null),
          ImportErrorKind.fileIsCorrupt,
        );
      });

      test('Shows settings dialog if backup data is decryptable', () async {
        // Setup
        final firstNoteContent = 'firstNoteContent';
        final firstNoteIv = enc.IV.fromLength(16);
        final dummyKey = enc.Key.fromLength(32);
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
              content: firstNoteContent,
              iv: firstNoteIv.base64,
              dateCreated: 'dateCreated',
            ),
          ],
        );
        container.read(masterKeyProvider.notifier).set(dummyKey);
        when(
          mockEncryptionService.keyCanDecrypt(firstNoteContent, dummyKey, firstNoteIv),
        ).thenReturn(true);

        final tempDir = Directory.systemTemp;
        final dummyFile = File('${tempDir.path}/dummyFile.json');
        await dummyFile.writeAsString(jsonEncode(dummyBackupData.toJson()));
        PlatformFile dummyPlatformFile = PlatformFile(
          name: 'dummyFile.json',
          size: await dummyFile.length(),
          bytes: await dummyFile.readAsBytes(),
          path: dummyFile.path,
        );
        container.listen(importControllerProvider, (previous, next) {});

        // Act
        await container
            .read(importControllerProvider.notifier)
            .validateImportFile(dummyPlatformFile);

        expect(
          container
              .read(importControllerProvider)
              ?.maybeWhen(askForSettings: (_) => true, orElse: () => false),
          isTrue,
        );
      });

      test('Shows password dialog if backup data is not decryptable', () async {
        // Setup
        final firstNoteContent = 'firstNoteContent';
        final firstNoteIv = enc.IV.fromLength(16);
        final dummyKey = enc.Key.fromLength(32);
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
              content: firstNoteContent,
              iv: firstNoteIv.base64,
              dateCreated: 'dateCreated',
            ),
          ],
        );
        container.read(masterKeyProvider.notifier).set(dummyKey);

        when(
          mockEncryptionService.keyCanDecrypt(firstNoteContent, dummyKey, firstNoteIv),
        ).thenReturn(false);

        final tempDir = Directory.systemTemp;
        final dummyFile = File('${tempDir.path}/dummyFile.json');
        await dummyFile.writeAsString(jsonEncode(dummyBackupData.toJson()));
        PlatformFile dummyPlatformFile = PlatformFile(
          name: 'dummyFile.json',
          size: await dummyFile.length(),
          bytes: await dummyFile.readAsBytes(),
          path: dummyFile.path,
        );
        container.listen(importControllerProvider, (previous, next) {});

        // Act
        await container
            .read(importControllerProvider.notifier)
            .validateImportFile(dummyPlatformFile);

        expect(
          container
              .read(importControllerProvider)
              ?.maybeWhen(showPasswordDialog: (_) => true, orElse: () => false),
          isTrue,
        );
      });
    });

    test('performKeyRotation works', () async {
      // Setup
      final oldKey = enc.Key.fromLength(32);
      final currentKey = enc.Key.fromLength(32);
      final oldIvString = enc.IV.fromLength(16).base64;
      final newIvString = enc.IV.fromLength(16).base64;
      const oldContent = 'oldEncryptedContent';
      const decryptedContent = 'decryptedContent';
      const newContent = 'newEncryptedContent';
      container.read(masterKeyProvider.notifier).set(currentKey);
      final note = NoteDto(
        id: '1',
        title: 'Test Note',
        content: oldContent,
        iv: oldIvString,
        dateCreated: DateTime.now().toIso8601String(),
      );
      final backupData = BackupData(
        credentialsData: CredentialsData(salt: 's', iv: 'i', encryptedMasterKey: 'k'),
        settingsData: SettingsData(
          exportSuggestions: true,
          exportWarnings: true,
          theme: ThemeMode.system,
        ),
        notesData: [note],
      );
      when(
        mockEncryptionService.decryptText(
          encryptedText: oldContent,
          key: oldKey,
          iv: anyNamed('iv'),
        ),
      ).thenReturn(decryptedContent);
      when(
        mockEncryptionService.encryptText(text: decryptedContent, key: currentKey),
      ).thenReturn((encryptedText: newContent, encryptionIV: newIvString));

      // Act
      final result = await container
          .read(importControllerProvider.notifier)
          .performKeyRotation(backupData: backupData, backupsMasterKey: oldKey);

      // Verify
      expect(result.notesData.first.content, newContent);
      expect(result.notesData.first.iv, newIvString);
      verify(
        mockEncryptionService.decryptText(
          encryptedText: oldContent,
          key: oldKey,
          iv: argThat(isA<enc.IV>(), named: 'iv'),
        ),
      ).called(1);
      verify(mockEncryptionService.encryptText(text: decryptedContent, key: currentKey)).called(1);
    });
  });
}
