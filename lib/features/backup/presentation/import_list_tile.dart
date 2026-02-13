import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:private_notes_light/features/backup/application/backup_service.dart';
import 'package:private_notes_light/features/backup/application/file_picker_running.dart';
import 'package:private_notes_light/features/backup/domain/import_exception.dart';
import 'package:private_notes_light/features/backup/presentation/import_settings_dialog.dart';
import 'package:private_notes_light/features/backup/presentation/overwrite_warning_dialog.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class ImportListTile extends ConsumerWidget {
  const ImportListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void triggerImport() async {
      // * Warn about overwrites if there are notes in the database.
      final notesList = await ref.read(noteRepositoryProvider).getNotes();
      bool? proceedImport =
          notesList.isEmpty; // if notes list is empty, automatically proceed import.
      if (notesList.isNotEmpty && context.mounted) {
        proceedImport = await showDialog<bool>(
          context: context,
          builder: (context) => const OverwriteWarningDialog(),
        );
      }
      if (proceedImport != true) {
        return;
      }

      if (!context.mounted) return;

      ref.read(filePickerRunningProvider.notifier).set(true);
      final pickerResult = await FilePicker.platform.pickFiles(
        dialogTitle: AppLocalizations.of(context)!.importSelectBackupTitle,
      );
      ref.read(filePickerRunningProvider.notifier).set(false);
      if (pickerResult == null || pickerResult.count == 0) return;

      final backupService = ref.read(backupServiceProvider.notifier);
      final pickedFileContent = await pickerResult.xFiles.first.readAsString();
      try {
        backupService.validateImportString(pickedFileContent);
      } on CouldNotParseJson catch (e) {
        if (context.mounted) showErrorSnackbar(context, content: e.message!);
        return;
      } on FileIsCorrupt catch (e) {
        if (context.mounted) showErrorSnackbar(context, content: e.message!);
        return;
      }

      // * Ask for settings import option.
      late final bool? alsoImportSettings;
      if (context.mounted) {
        alsoImportSettings = await showDialog<bool>(
          context: context,
          builder: (context) => const ImportSettingsDialog(),
        );
      }

      await backupService.processImport(pickedFileContent, alsoImportSettings ?? false);
      if (context.mounted) {
        showSuccessSnackbar(context, content: AppLocalizations.of(context)!.importSuccess);
        Navigator.of(context).pop();
      }
    }

    return ListTile(
      leading: const Icon(Icons.download_rounded),
      title: Text(AppLocalizations.of(context)!.importDataTitle),
      subtitle: Text(AppLocalizations.of(context)!.importDataSubtitle),
      onTap: triggerImport,
    );
  }
}
