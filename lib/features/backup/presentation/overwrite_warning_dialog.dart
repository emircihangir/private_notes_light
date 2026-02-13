import 'package:flutter/material.dart';

class OverwriteWarningDialog extends StatelessWidget {
  const OverwriteWarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: const Text(
        'Choosing Proceed will overwrite or delete your existing notes. Choose Abort to keep them.',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Abort')),
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('Proceed')),
      ],
    );
  }
}
