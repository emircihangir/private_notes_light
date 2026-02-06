import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, {String content = 'Error occurred.'}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content, style: TextStyle(color: Theme.of(context).colorScheme.onError)),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}
