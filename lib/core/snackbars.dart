import 'package:flutter/material.dart';

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
      content: Text(content, style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface)),
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
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
