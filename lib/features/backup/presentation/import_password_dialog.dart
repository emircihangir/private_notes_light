import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/authentication/presentation/password_text_field.dart';
import 'package:private_notes_light/features/backup/application/import_controller.dart';
import 'package:private_notes_light/features/backup/domain/backup_data.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class ImportPasswordDialog extends ConsumerStatefulWidget {
  final BackupData backupData;
  const ImportPasswordDialog(this.backupData, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImportPasswordDialogState();
}

class _ImportPasswordDialogState extends ConsumerState<ImportPasswordDialog> {
  final controller = TextEditingController();
  String? errorText;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    log('Disposed the password text field controller.', name: 'INFO');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.importPasswordDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Text(AppLocalizations.of(context)!.importPasswordDialogContent),
          Form(
            child: PasswordTextField(controller: controller, errorText: errorText),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () async {
            final rotatedBackupData = await ref
                .read(importControllerProvider.notifier)
                .submitPassword(widget.backupData, controller.text);

            if (rotatedBackupData == null) {
              setState(() => errorText = AppLocalizations.of(context)!.wrongPasswordError);
            } else if (context.mounted) {
              Navigator.of(context).pop();
              log('Closed the password dialog.', name: 'INFO');
              ref.read(importControllerProvider.notifier).askForSettings(rotatedBackupData);
            }
          },
          child: Text(AppLocalizations.of(context)!.submitButton),
        ),
      ],
    );
  }
}
