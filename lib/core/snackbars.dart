import 'package:flutter/material.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

void showErrorSnackbar(BuildContext context, {String content = 'Error occurred.'}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content, style: TextStyle(color: Theme.of(context).colorScheme.onError)),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}

void showInfoSnackbar(BuildContext context, {required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: TextStyle(color: Theme.of(context).colorScheme.onInverseSurface),
      ),
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
    ),
  );
}

void showSuccessSnackbar(BuildContext context, {required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      backgroundColor: Theme.of(context).colorScheme.primary,
    ),
  );
}

void showExportSuggestionSnackbar(BuildContext context, VoidCallback onPressed) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        AppLocalizations.of(context)!.exportSuggestionSnackbar,
        style: TextStyle(color: Theme.of(context).colorScheme.onInverseSurface),
      ),
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      action: SnackBarAction(label: AppLocalizations.of(context)!.export, onPressed: onPressed),
      showCloseIcon: true,
    ),
  );
}

void showExportWarningSnackbar(BuildContext context, VoidCallback onPressed) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        AppLocalizations.of(context)!.exportWarningSnackbar,
        style: TextStyle(color: Theme.of(context).colorScheme.onInverseSurface),
      ),
      backgroundColor: Theme.of(context).colorScheme.inverseSurface,
      action: SnackBarAction(label: AppLocalizations.of(context)!.export, onPressed: onPressed),
    ),
  );
}
