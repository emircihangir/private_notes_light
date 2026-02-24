import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:private_notes_light/features/backup/application/file_picker_service.dart';
import 'package:private_notes_light/features/backup/application/path_service.dart';
import 'package:private_notes_light/features/backup/data/backup_repository.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/settings/data/settings_repository.dart';
import 'package:private_notes_light/features/settings/domain/settings_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/dummy_backup_data.dart';

@GenerateNiceMocks([
  MockSpec<PathService>(),
  MockSpec<FilePickerService>(),
  MockSpec<NoteRepository>(),
  MockSpec<SettingsRepository>(),
])
import 'backup_repository_test.mocks.dart';

void main() {
  late MockPathService mockPathService;
  late MockFilePickerService mockFilePickerService;
  late MockNoteRepository mockNoteRepo;
  late MockSettingsRepository mockSettingsRepo;
  late ProviderContainer container;

  setUp(() {
    mockPathService = MockPathService();
    mockFilePickerService = MockFilePickerService();
    mockNoteRepo = MockNoteRepository();
    mockSettingsRepo = MockSettingsRepository();
    container = ProviderContainer(
      overrides: [
        pathServiceProvider.overrideWith((ref) => mockPathService),
        filePickerServiceProvider.overrideWith((ref) => mockFilePickerService),
        noteRepositoryProvider.overrideWith((ref) => mockNoteRepo),
        settingsRepositoryProvider.overrideWith((ref) => mockSettingsRepo),
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

  group('import works', () {
    test('calls NoteRepository.import()', () async {
      // Act
      final backupRepository = await container.read(backupRepositoryProvider.future);
      backupRepository.import(dummyBackupData(), false);

      // Verify
      verify(mockNoteRepo.importNotes(argThat(isA<List<NoteDto>?>()))).called(1);
    });
    group(
      'SettingsRepository.importSettings() execution aligns with alsoImportSettings parameter',
      () {
        test('calls when true', () async {
          // Act
          final backupRepository = await container.read(backupRepositoryProvider.future);
          await backupRepository.import(dummyBackupData(), true);

          // Verify
          verify(mockSettingsRepo.importSettings(argThat(isA<SettingsData?>()))).called(1);
        });
        test('does not call when false', () async {
          // Act
          final backupRepository = await container.read(backupRepositoryProvider.future);
          await backupRepository.import(dummyBackupData(), false);

          // Verify
          verifyNever(mockSettingsRepo.importSettings(argThat(isA<SettingsData?>())));
        });
      },
    );
  });
}
