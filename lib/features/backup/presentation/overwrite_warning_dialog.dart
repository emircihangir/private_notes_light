import 'package:flutter/material.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class OverwriteWarningDialog extends StatelessWidget {
  const OverwriteWarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.areYouSure),
      content: Text(AppLocalizations.of(context)!.overwriteWarningContent),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(AppLocalizations.of(context)!.proceed),
        ),
      ],
    );
  }
}
