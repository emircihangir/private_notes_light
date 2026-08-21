import 'package:flutter/material.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class ImportSettingsDialog extends StatelessWidget {
  const ImportSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.importSettingsDialogTitle),
      content: Text(l10n.importSettingsDialogContent),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.no)),
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.yes)),
      ],
    );
  }
}
