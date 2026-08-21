import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/authentication/presentation/password_text_field.dart';
import 'package:private_notes_light/features/backup/application/import_controller.dart';
import 'package:private_notes_light/features/backup/domain/backup_data.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class ImportPasswordDialog extends ConsumerStatefulWidget {
  final BackupData backupData;
  final String? dialogContent;
  final bool? skipSettingsDialog;
  const ImportPasswordDialog(this.backupData, {super.key, this.dialogContent, this.skipSettingsDialog});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ImportPasswordDialogState();
}

class _ImportPasswordDialogState extends ConsumerState<ImportPasswordDialog> {
  final controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorText;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    log('Disposed the password text field controller in import password dialog.', name: 'INFO');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.importPasswordDialogTitle),
      content: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.dialogContent ?? l10n.importPasswordDialogContent),
          Form(
            key: _formKey,
            child: PasswordTextField(controller: controller, errorText: errorText, autoFocus: true),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        TextButton(
          key: const ValueKey('SubmitButton'),
          onPressed: () async {
            if (_formKey.currentState!.validate() == false) return;

            final rotatedBackupData = await ref
                .read(importControllerProvider.notifier)
                .submitPassword(widget.backupData, controller.text);

            if (rotatedBackupData == null) {
              setState(() => errorText = l10n.wrongPasswordError);
            } else if (context.mounted) {
              Navigator.of(context).pop();
              log('Closed the password dialog.', name: 'INFO');
              if (widget.skipSettingsDialog == true) {
                ref.read(importControllerProvider.notifier).executeImport(rotatedBackupData, true);
              } else {
                ref.read(importControllerProvider.notifier).askForSettings(rotatedBackupData);
              }
            }
          },
          child: Text(l10n.submitButton),
        ),
      ],
    );
  }
}
