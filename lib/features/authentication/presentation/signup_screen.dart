import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/authentication/application/auth_service.dart';
import 'package:private_notes_light/features/notes/presentation/notes_page.dart';
import 'package:private_notes_light/features/authentication/presentation/password_text_field.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
    log('Disposed the password text field controller.', name: 'INFO');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            spacing: 32,
            children: [
              Text(
                AppLocalizations.of(context)!.welcome,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  AppLocalizations.of(context)!.masterPasswordSetupWarning,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
              Form(
                key: _formKey,
                child: PasswordTextField(
                  controller: passwordController,
                  hintText: AppLocalizations.of(context)!.masterPasswordHint,
                  onChanged: (value) {
                    if (value.isNotEmpty) _formKey.currentState!.validate();
                  },
                ),
              ),
              FilledButton(
                onPressed: () async {
                  final isValid = _formKey.currentState!.validate();
                  if (isValid == false) return;

                  final passwordInput = passwordController.text;
                  try {
                    await ref.read(authServiceProvider.notifier).signup(passwordInput);
                    if (context.mounted) {
                      passwordController.clear();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => NotesPage()),
                        (route) => false,
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showErrorSnackbar(
                        context,
                        content: AppLocalizations.of(context)!.signupGenericError,
                      );
                    }
                  }
                },
                child: Text(AppLocalizations.of(context)!.signupButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
