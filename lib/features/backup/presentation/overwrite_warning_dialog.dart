import 'package:flutter/material.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class OverwriteWarningDialog extends StatelessWidget {
  const OverwriteWarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.areYouSure),
      content: Text(l10n.overwriteWarningContent),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancel)),
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.proceed)),
      ],
    );
  }
}
