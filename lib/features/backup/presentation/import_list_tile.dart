import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:private_notes_light/features/backup/application/import_controller.dart';
import 'package:private_notes_light/features/backup/domain/import_controller_state.dart';
import 'package:private_notes_light/features/backup/presentation/import_password_dialog.dart';
import 'package:private_notes_light/features/backup/presentation/import_settings_dialog.dart';
import 'package:private_notes_light/features/backup/presentation/overwrite_warning_dialog.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class ImportListTile extends ConsumerWidget {
  const ImportListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    ref.listen(importControllerProvider, (previous, next) async {
      next?.map(
        showOverwriteWarning: (_) async {
          final filePickerTitle = l10n.importSelectBackupTitle;

          bool? proceedImport = await showDialog<bool>(
            context: context,
            builder: (context) => const OverwriteWarningDialog(),
          );

          if (proceedImport == true) {
            ref
                .read(importControllerProvider.notifier)
                .showFilePicker(dialogTitle: filePickerTitle);
          }
        },
        showError: (value) {
          switch (value.errorKind) {
            case ImportErrorKind.invalidFileType:
              showErrorSnackbar(context, content: l10n.invalidFileType);

            case ImportErrorKind.fileIsCorrupt:
              showErrorSnackbar(context, content: l10n.fileIsCorrupt);

            case ImportErrorKind.couldNotParseJson:
              showErrorSnackbar(context, content: l10n.couldNotParseJson);
          }
        },
        showSuccess: (value) {
          showSuccessSnackbar(context, content: l10n.importSuccess);
          Navigator.of(context).pop();
        },
        showPasswordDialog: (value) async {
          await showDialog(
            context: context,
            builder: (context) => ImportPasswordDialog(value.backupData),
          );
        },
        askForSettings: (value) async {
          log('Opening the settings dialog');
          final bool? alsoImportSettings = await showDialog<bool>(
            context: context,
            builder: (context) => const ImportSettingsDialog(),
          );
          await ref
              .read(importControllerProvider.notifier)
              .executeImport(value.backupData, alsoImportSettings ?? false);
        },
      );
    });

    return ListTile(
      key: const ValueKey('ImportListTile'),
      leading: const Icon(Icons.download_rounded),
      title: Text(l10n.importDataTitle),
      subtitle: Text(l10n.importDataSubtitle),
      onTap: () async => await ref
          .read(importControllerProvider.notifier)
          .startImport(dialogTitle: l10n.importSelectBackupTitle),
    );
  }
}
