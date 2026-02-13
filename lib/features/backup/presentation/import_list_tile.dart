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

class ImportListTile extends ConsumerWidget {
  const ImportListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void triggerImport() async {
      ref.read(filePickerRunningProvider.notifier).set(true);
      final pickerResult = await FilePicker.platform.pickFiles(dialogTitle: 'Select a Backup File');
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

      // * Warn about overwrites if there are notes in the database.
      final notesList = await ref.read(noteRepositoryProvider).getNotes();
      late final bool? proceedImport;
      if (notesList.isNotEmpty && context.mounted) {
        proceedImport = await showDialog<bool>(
          context: context,
          builder: (context) => OverwriteWarningDialog(),
        );
      }

      if (proceedImport != true) return;

      // * Ask for settings import option.
      late final bool? alsoImportSettings;
      if (context.mounted) {
        alsoImportSettings = await showDialog<bool>(
          context: context,
          builder: (context) => ImportSettingsDialog(),
        );
      }

      await backupService.processImport(pickedFileContent, alsoImportSettings ?? false);
      if (context.mounted) {
        showSuccessSnackbar(context, 'Import successful.');
        Navigator.of(context).pop();
      }
    }

    return ListTile(
      leading: const Icon(Icons.download_rounded),
      title: const Text('Import Data'),
      subtitle: const Text('Restore notes from a backup file'),
      onTap: triggerImport,
    );
  }
}
