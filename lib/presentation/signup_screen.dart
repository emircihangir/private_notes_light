import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/application/auth_service.dart';
import 'package:private_notes_light/presentation/notes_page.dart';
import 'package:private_notes_light/presentation/password_text_field.dart';
import 'package:private_notes_light/presentation/snackbars.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
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
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  'Please set up a master password. Be careful, there is no way to unlock your notes without the master password.',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              PasswordTextField(
                onChanged: (value) => passwordInput = value,
                hintText: 'Master Password',
              ),
              FilledButton(
                onPressed: () async {
                  try {
                    if (passwordInput.isEmpty) {
                      showEmptyInputSnackbar(context, inputName: 'Master password');
                      return;
                    }

                    await ref.read(authServiceProvider.notifier).signup(passwordInput);
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => NotesPage()),
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showErrorSnackbar(context, content: 'Signup failed. Please try again.');
                    }
                  }
                },
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
