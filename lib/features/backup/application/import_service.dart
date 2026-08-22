import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/backup/data/backup_repository.dart';
import 'package:private_notes_light/features/backup/domain/backup_data.dart';
import 'package:private_notes_light/features/backup/domain/validation_result.dart';
import 'package:private_notes_light/features/encryption/application/encryption_service.dart';
import 'package:private_notes_light/features/encryption/application/master_key.dart';
import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/settings/application/settings_controller.dart';
import 'package:encrypt/encrypt.dart' as enc;

class ImportService {
  final Ref ref;
  const new(this.ref);

  Future<ValidationResult> validateImportFile(PlatformFile importFile) async {
    late final String importString;
    try {
      importString = await importFile.xFile.readAsString();
    } catch (e) {
      return .invalidFileType;
    }

    late final Map<String, dynamic> importJson;
    try {
      importJson = jsonDecode(importString);
    } catch (e) {
      return .couldNotParseJson;
    }

    try {
      BackupData.fromJson(importJson);
    } catch (e) {
      return .fileIsCorrupt;
    }

    return .valid;
  }

  Future<BackupData> parseBackupData(PlatformFile importFile) async {
    assert(await validateImportFile(importFile) == .valid);

    final importString = await importFile.xFile.readAsString();
    final importJson = jsonDecode(importString);
    return BackupData.fromJson(importJson);
  }

  Future<void> executeImport(BackupData backupData, bool alsoImportSettings) async {
    final backupRepo = await ref.read(backupRepositoryProvider.future);
    await backupRepo.import(backupData, alsoImportSettings);

    // * Trigger provider rebuilds.
    ref.invalidate(noteControllerProvider);
    ref.invalidate(settingsControllerProvider);
  }

  Future<BackupData> performKeyRotation({required BackupData backupData, required enc.Key backupsMasterKey}) async {
    final encryptionService = ref.read(encryptionServiceProvider);
    final currentMasterKey = ref.read(masterKeyProvider)!;

    final currentNotesList = List<NoteDto>.from(backupData.notesData);
    List<NoteDto> updatedNotesList = [];
    for (NoteDto currentNote in currentNotesList) {
      // * Decrypt with backup's master key.
      final decryptedContent = encryptionService.decryptText(
        encryptedText: currentNote.content,
        key: backupsMasterKey,
        iv: enc.IV.fromBase64(currentNote.iv),
      );

      // * Encrypt with the current master key.
      final reEncrypted = encryptionService.encryptText(text: decryptedContent, key: currentMasterKey);
      final updateNote = currentNote.copyWith(content: reEncrypted.encryptedText, iv: reEncrypted.encryptionIV.base64);

      updatedNotesList.add(updateNote);
    }

    log('Performed key rotation.', name: 'INFO');

    return backupData.copyWith(notesData: updatedNotesList);
  }

  Future<bool> notesExist() async => (await ref.read(noteRepositoryProvider).getNotes()).isNotEmpty;

  enc.Key? decryptBackupCredentials({required BackupData backupData, required enc.Key key}) {
    final encryptionService = ref.read(encryptionServiceProvider);
    final backupCredentials = backupData.credentialsData;

    try {
      final decryptedString = encryptionService.decryptText(
        encryptedText: backupCredentials.encryptedMasterKey,
        key: key,
        iv: enc.IV.fromBase64(backupCredentials.iv),
      );
      return enc.Key.fromBase64(decryptedString);
    } catch (e) {
      return null;
    }
  }

  Future<enc.Key?> tryPassword(String password, BackupData backupData) async {
    final enc.Key derivedKey = await ref
        .read(encryptionServiceProvider)
        .deriveKeyFromPassword(password, backupData.credentialsData.salt);
    final decryptedBackupKey = decryptBackupCredentials(backupData: backupData, key: derivedKey);

    return decryptedBackupKey;
  }
}

final importServiceProvider = Provider((ref) => ImportService(ref));
