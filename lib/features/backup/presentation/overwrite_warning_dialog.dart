import 'package:flutter/material.dart';

class OverwriteWarningDialog extends StatelessWidget {
  const OverwriteWarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text(
        'You currently have notes saved in the database. Importing will override or delete existing notes.',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Proceed')),
      ],
    );
  }
}
