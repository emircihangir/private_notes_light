import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/application/auth_service.dart';
import 'package:private_notes_light/presentation/notes_page.dart';
import 'package:private_notes_light/presentation/password_text_field.dart';
import 'package:private_notes_light/presentation/snackbars.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String passwordInput = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            spacing: 32,
            children: [
              Text('Welcome', style: Theme.of(context).textTheme.headlineLarge),
              PasswordTextField(onChanged: (value) => passwordInput = value),
              FilledButton(
                onPressed: () async {
                  if (passwordInput.isEmpty) {
                    showEmptyInputSnackbar(context, inputName: 'Password');
                    return;
                  }

                  final loggedIn = await ref
                      .read(authServiceProvider.notifier)
                      .login(passwordInput);
                  if (!context.mounted) return;

                  if (loggedIn) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => NotesPage()),
                      (route) => false,
                    );
                  } else {
                    showPasswordWrongSnackbar(context);
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
