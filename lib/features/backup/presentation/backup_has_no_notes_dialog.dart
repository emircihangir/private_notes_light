import 'package:flutter/material.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class BackupHasNoNotesDialog extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.backupHasNoNotesDialogTitle),
      content: Text(l10n.backupHasNoNotesDialogContent),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.ok))],
    );
  }
}
