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
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  String? errorText2;

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
    log('Disposed the password text field controllers.', name: 'INFO');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                PasswordTextField(
                  controller: controller1,
                  canBeToggled: false,
                  hintText: AppLocalizations.of(context)!.masterPasswordHint,
                  textInputAction: TextInputAction.next,
                ),
                PasswordTextField(
                  controller: controller2,
                  canBeToggled: false,
                  hintText: AppLocalizations.of(context)!.masterPasswordConfirm,
                  errorText: errorText2,
                  onChanged: (value) {
                    if (errorText2 != null) setState(() => errorText2 = null);
                  },
                ),
                FilledButton(
                  onPressed: () async {
                    final isValid = _formKey.currentState!.validate();
                    if (isValid == false) return;

                    if (controller1.text != controller2.text) {
                      setState(() => errorText2 = AppLocalizations.of(context)!.passwordsDontMatch);
                      return;
                    } else if (errorText2 != null) {
                      setState(() => errorText2 = null);
                    }

                    final passwordInput = controller2.text;
                    try {
                      await ref.read(authServiceProvider).signup(passwordInput);
                      if (context.mounted) {
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
      ),
    );
  }
}
