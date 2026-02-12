import 'dart:convert';
import 'package:private_notes_light/features/authentication/data/auth_repository.dart';
import 'package:private_notes_light/features/backup/data/backup_repository.dart';
import 'package:private_notes_light/features/backup/domain/backup_data.dart';
import 'package:private_notes_light/features/backup/domain/import_exception.dart';
import 'package:private_notes_light/features/encryption/application/encryption_service.dart';
import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/settings/application/settings_controller.dart';
import 'package:private_notes_light/features/settings/data/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backup_service.g.dart';

@riverpod
class BackupService extends _$BackupService {
  @override
  FutureOr<void> build() {}

  Future<void> export() async {
    final backupRepo = await ref.watch(backupRepositoryProvider.future);
    final authRepo = ref.watch(authRepositoryProvider);
    final noteRepo = ref.watch(noteRepositoryProvider);
    final settingsRepo = await ref.watch(settingsRepositoryProvider.future);

    final exportData = BackupData(
      credentialsData: await authRepo.readCredentials(),
      settingsData: settingsRepo.getSettings(),
      notesData: await noteRepo.getNotes(),
    );

    // * Convert BackupData.notesData from List<NoteDto> to List<Map<String, dynamic>>.
    final exportDataMap = exportData.toJson();
    final List<NoteDto> notesData = exportDataMap[BackupData.propertyNames.notesData];
    final List<Map<String, dynamic>> expandedNotesData = [];
    for (int i = 0; i < notesData.length; i++) {
      expandedNotesData.add(notesData[i].toJson());
    }
    exportDataMap[BackupData.propertyNames.notesData] = expandedNotesData;

    await backupRepo.export(exportDataMap);
  }

  void validateImportString(String importString) {
    // * Try to convert String to Map<String, dynamic>.
    late final Map<String, dynamic> importJson;
    try {
      importJson = jsonDecode(importString);
    } catch (e) {
      throw CouldNotParseJson();
    }

    // * Try to convert Map<String, dynamic> to BackupData.
    try {
      BackupData.fromJson(importJson);
    } catch (e) {
      throw FileIsCorrupt();
    }
  }

  Future<void> processImport(String importString) async {
    // * Convert String to Map<String, dynamic>.
    final Map<String, dynamic> importJson = jsonDecode(importString);

    // * Convert Map<String, dynamic> to BackupData.
    final BackupData backupData = BackupData.fromJson(importJson);

    // * Try to decrypt first note's content with the current master key.
    final encryptionService = ref.watch(encryptionServiceProvider.notifier);
    final NoteDto firstNote = backupData.notesData.first;
    try {
      encryptionService.decryptWithMasterKey(firstNote.content, firstNote.iv);

      // Current master key is capable of decrypting note contents.
      // * Execute import.
      final backupRepo = await ref.watch(backupRepositoryProvider.future);
      await backupRepo.import(backupData);

      // * Trigger provider rebuilds.
      ref.invalidate(noteControllerProvider);
      ref.invalidate(settingsControllerProvider);
    } catch (e) {
      // Current master key fails to decrypt note contents.
      // * Trigger password input.
      throw RequiresPasswordInput(backupData);
    }
  }
}
