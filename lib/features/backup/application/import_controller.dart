import 'dart:convert';
import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:private_notes_light/features/backup/application/file_picker_running.dart';
import 'package:private_notes_light/features/backup/data/backup_repository.dart';
import 'package:private_notes_light/features/backup/domain/backup_data.dart';
import 'package:private_notes_light/features/backup/domain/import_controller_state.dart';
import 'package:private_notes_light/features/encryption/application/encryption_service.dart';
import 'package:private_notes_light/features/encryption/application/master_key.dart';
import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/settings/application/settings_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:encrypt/encrypt.dart' as enc;

part 'import_controller.g.dart';

@riverpod
class ImportController extends _$ImportController {
  @override
  ImportControllerState? build() => null;

  Future<void> validateImportFile(PlatformFile importFile) async {
    late final String importString;
    try {
      importString = await importFile.xFile.readAsString();
    } catch (e) {
      state = ImportControllerState.showError(errorKind: ImportErrorKind.invalidFileType);
      return;
    }

    // * Try to convert String to Map<String, dynamic>.
    late final Map<String, dynamic> importJson;
    try {
      importJson = jsonDecode(importString);
    } catch (e) {
      state = ImportControllerState.showError(errorKind: ImportErrorKind.couldNotParseJson);
      return;
    }

    // * Try to convert Map<String, dynamic> to BackupData.
    late final BackupData backupData;
    try {
      backupData = BackupData.fromJson(importJson);
    } catch (e) {
      state = ImportControllerState.showError(errorKind: ImportErrorKind.fileIsCorrupt);
      return;
    }

    final isDecryptable = _keyCanDecryptNotes(backupData, ref.read(masterKeyProvider)!);

    if (isDecryptable) {
      askForSettings(backupData);
    } else {
      state = ImportControllerState.showPasswordDialog(backupData);
    }
  }

  bool _keyCanDecryptNotes(BackupData backupData, enc.Key key) {
    // * Try to decrypt first note's content with key.
    final encryptionService = ref.watch(encryptionServiceProvider);
    final NoteDto firstNote = backupData.notesData.first;
    try {
      encryptionService.decryptText(
        encryptedText: firstNote.content,
        key: key,
        iv: enc.IV.fromBase64(firstNote.iv),
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> showFilePicker({required String dialogTitle}) async {
    ref.read(filePickerRunningProvider.notifier).set(true);
    final pickerResult = await FilePicker.platform.pickFiles(dialogTitle: dialogTitle);
    ref.read(filePickerRunningProvider.notifier).set(false);

    if (pickerResult == null || pickerResult.count == 0) return;

    validateImportFile(pickerResult.files.first);
  }

  Future<void> executeImport(BackupData backupData, bool alsoImportSettings) async {
    final backupRepo = await ref.watch(backupRepositoryProvider.future);
    await backupRepo.import(backupData, alsoImportSettings);

    // * Trigger provider rebuilds.
    ref.invalidate(noteControllerProvider);
    ref.invalidate(settingsControllerProvider);

    state = ImportControllerState.showSuccess();
  }

  Future<BackupData> _performKeyRotation({
    required BackupData backupData,
    required enc.Key backupsMasterKey,
  }) async {
    final encryptionService = ref.watch(encryptionServiceProvider);
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
      final reEncrypted = encryptionService.encryptText(
        text: decryptedContent,
        key: currentMasterKey,
      );
      final updateNote = currentNote.copyWith(
        content: reEncrypted.encryptedText,
        iv: reEncrypted.encryptionIV,
      );

      updatedNotesList.add(updateNote);
    }

    log('Performed key rotation.', name: 'INFO');

    return backupData.copyWith(notesData: updatedNotesList);
  }

  Future<bool> notesExist() async => (await ref.read(noteRepositoryProvider).getNotes()).isNotEmpty;

  Future<void> startImport({required String dialogTitle}) async {
    // * Warn about overwrites if there are notes in the database.
    final notesList = await ref.read(noteRepositoryProvider).getNotes();
    if (notesList.isNotEmpty) {
      state = ImportControllerState.showOverwriteWarning();
    } else {
      showFilePicker(dialogTitle: dialogTitle);
    }
  }

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

  void askForSettings(BackupData backupData) =>
      state = ImportControllerState.askForSettings(backupData);

  Future<BackupData?> submitPassword(BackupData backupData, String password) async {
    final enc.Key derivedKey = await ref
        .read(encryptionServiceProvider)
        .deriveKeyFromPassword(password, backupData.credentialsData.salt);

    final decryptedBackupKey = decryptBackupCredentials(backupData: backupData, key: derivedKey);

    if (decryptedBackupKey != null) {
      final rotatedBackupData = await _performKeyRotation(
        backupData: backupData,
        backupsMasterKey: decryptedBackupKey,
      );
      return rotatedBackupData;
    } else {
      log('User entered the wrong password.', name: 'INFO');
      return null;
    }
  }
}
