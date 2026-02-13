import 'package:flutter/material.dart';

class ImportSettingsDialog extends StatelessWidget {
  const ImportSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Import settings?'),
      content: const Text('Selecting Yes will overwrite your current settings.'),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('No')),
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Yes')),
      ],
    );
  }
}
