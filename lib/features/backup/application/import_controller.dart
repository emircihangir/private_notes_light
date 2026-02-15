import 'dart:convert';
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
    final importString = await importFile.xFile.readAsString();

    // * Try to convert String to Map<String, dynamic>.
    late final Map<String, dynamic> importJson;
    try {
      importJson = jsonDecode(importString);
    } catch (e) {
      state = ImportControllerState.showError(errorKind: ImportErrorKind.couldNotParseJson);
      return;
    }

    // * Try to convert Map<String, dynamic> to BackupData.
    try {
      final backupData = BackupData.fromJson(importJson);
      state = ImportControllerState.askForSettings(backupData);
      return;
    } catch (e) {
      state = ImportControllerState.showError(errorKind: ImportErrorKind.fileIsCorrupt);
      return;
    }
  }

  bool _keyCanDecryptNotes(BackupData backupData, enc.Key key) {
    // * Try to decrypt first note's content with key.
    final encryptionService = ref.watch(encryptionServiceProvider.notifier);
    final NoteDto firstNote = backupData.notesData.first;
    try {
      encryptionService.decryptText(
        encryptedText: firstNote.content,
        key: key,
        iv: enc.IV.fromBase64(firstNote.iv),
      );

      return true;
    } catch (e) {
      return true;
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
    final encryptionService = ref.watch(encryptionServiceProvider.notifier);
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

  Future<void> submitPassword(BackupData backupData, String password) async {
    final enc.Key derivedKey = await ref
        .read(encryptionServiceProvider.notifier)
        .deriveKeyFromPassword(password, backupData.credentialsData.salt);

    if (_keyCanDecryptNotes(backupData, derivedKey)) {
      _performKeyRotation(backupData: backupData, backupsMasterKey: derivedKey);
    } else {
      state = ImportControllerState.showPasswordDialog();
    }
  }
}
