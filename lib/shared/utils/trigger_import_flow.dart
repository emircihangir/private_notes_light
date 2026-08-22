import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:private_notes_light/features/authentication/data/auth_repository.dart';
import 'package:private_notes_light/features/backup/application/file_picker_running.dart';
import 'package:private_notes_light/features/backup/application/file_picker_service.dart';
import 'package:private_notes_light/features/backup/application/import_service.dart';
import 'package:private_notes_light/features/backup/presentation/backup_has_no_notes_dialog.dart';
import 'package:private_notes_light/features/backup/presentation/import_password_dialog.dart';
import 'package:private_notes_light/features/backup/presentation/import_settings_dialog.dart';
import 'package:private_notes_light/features/backup/presentation/overwrite_warning_dialog.dart';
import 'package:private_notes_light/features/encryption/application/encryption_service.dart';
import 'package:private_notes_light/features/encryption/application/master_key.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

Future<void> triggerImportFlow(BuildContext context, WidgetRef ref, {required VoidCallback onSuccessfulImport}) async {
  final l10n = AppLocalizations.of(context)!;

  final hasNotes = await ref.read(noteRepositoryProvider).hasNotes;
  if (!context.mounted) return;

  if (hasNotes) {
    bool? proceedImport = await showDialog<bool>(context: context, builder: (_) => const OverwriteWarningDialog());
    if (proceedImport != true) return;
  }

  ref.read(filePickerRunningProvider.notifier).set(true);
  final pickerResult = await ref.read(filePickerServiceProvider).pickFiles(dialogTitle: l10n.importSelectBackupTitle);
  ref.read(filePickerRunningProvider.notifier).set(false);
  if (pickerResult == null || pickerResult.count == 0) return;

  final importService = ref.read(importServiceProvider);
  final importFile = pickerResult.files.first;
  final validationResult = await importService.validateImportFile(importFile);
  if (!context.mounted) return;

  switch (validationResult) {
    case .fileIsCorrupt:
      showErrorSnackbar(context, content: l10n.fileIsCorrupt);
      return;
    case .couldNotParseJson:
      showErrorSnackbar(context, content: l10n.couldNotParseJson);
      return;
    case .invalidFileType:
      showErrorSnackbar(context, content: l10n.invalidFileType);
      return;
    case .valid:
      break;
  }

  final backupData = await importService.parseBackupData(importFile);
  if (!context.mounted) return;

  if (backupData.notesData.isEmpty) {
    showDialog(context: context, builder: (context) => const BackupHasNoNotesDialog());
    return;
  }

  final firstNote = backupData.notesData.first;
  final bool isDecryptable;
  final masterKey = ref.read(masterKeyProvider);
  final userIsSignedUp = masterKey != null;

  if (userIsSignedUp) {
    isDecryptable = ref
        .read(encryptionServiceProvider)
        .keyCanDecrypt(firstNote.content, masterKey, enc.IV.fromBase64(firstNote.iv));
  } else {
    isDecryptable = false;
  }

  if (isDecryptable) {
    // * backupData can be directly imported.

    final bool? alsoImportSettings = await showDialog<bool>(
      context: context,
      builder: (context) => const ImportSettingsDialog(),
    );
    await importService.executeImport(backupData, alsoImportSettings ?? false);
    if (!context.mounted) return;
    onSuccessfulImport();
    return;
  } else {
    // * backupData requires key rotation.

    late final String passwordDialogContent;
    if (userIsSignedUp) {
      passwordDialogContent = l10n.importPasswordDialogContent;
    } else {
      passwordDialogContent = l10n.signupBackupPasswordDialogContent;
    }

    late final enc.Key decryptedBackupKey;
    final submissionSuccessful = await showDialog<bool>(
      context: context,
      builder: (context) {
        return ImportPasswordDialog(
          dialogContent: passwordDialogContent,
          onPasswordSubmitted: (String submittedPassword) async {
            final result = await importService.tryPassword(submittedPassword, backupData);
            if (result != null) decryptedBackupKey = result;
            return result != null;
          },
        );
      },
    );
    if (submissionSuccessful != true) return;
    if (!context.mounted) return;

    if (userIsSignedUp) {
      final bool? alsoImportSettings = await showDialog<bool>(
        context: context,
        builder: (context) => const ImportSettingsDialog(),
      );
      final rotatedBackupData = await importService.performKeyRotation(
        backupData: backupData,
        backupsMasterKey: decryptedBackupKey,
      );
      await importService.executeImport(rotatedBackupData, alsoImportSettings ?? false);
      if (!context.mounted) return;
      onSuccessfulImport();
      return;
    } else {
      await ref.read(authRepositoryProvider).saveCredentials(backupData.credentialsData);
      ref.read(masterKeyProvider.notifier).set(decryptedBackupKey);
      await importService.executeImport(backupData, true);
      if (!context.mounted) return;
      onSuccessfulImport();
      return;
    }
  }
}
