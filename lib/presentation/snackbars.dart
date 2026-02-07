import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, {String content = 'Error occurred.'}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content, style: TextStyle(color: Theme.of(context).colorScheme.onError)),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}

void showPasswordWrongSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Wrong password. Try again.',
        style: TextStyle(color: Theme.of(context).colorScheme.onError),
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}

void showEmptyInputSnackbar(BuildContext context, {String inputName = 'input'}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '$inputName cannot be empty.',
        style: TextStyle(color: Theme.of(context).colorScheme.onError),
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}

void showLoginAgainSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'The app lost focus. Please login again.',
        style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
      ),
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
    ),
  );
}
