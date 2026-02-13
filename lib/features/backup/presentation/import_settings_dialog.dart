import 'package:flutter/material.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class ImportSettingsDialog extends StatelessWidget {
  const ImportSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.importSettingsDialogTitle),
      content: Text(AppLocalizations.of(context)!.importSettingsDialogContent),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context)!.no),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(AppLocalizations.of(context)!.yes),
        ),
      ],
    );
  }
}
