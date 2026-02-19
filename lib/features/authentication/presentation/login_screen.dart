import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/core/fade_page_route_builder.dart';
import 'package:private_notes_light/features/authentication/application/auth_service.dart';
import 'package:private_notes_light/features/notes/presentation/notes_page.dart';
import 'package:private_notes_light/features/authentication/presentation/password_text_field.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorText;

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
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 32,
            children: [
              Text(
                AppLocalizations.of(context)!.welcome,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Form(
                key: _formKey,
                child: PasswordTextField(
                  controller: passwordController,
                  errorText: errorText,
                  onChanged: (value) {
                    if (errorText != null) setState(() => errorText = null);
                  },
                ),
              ),
              FilledButton(
                onPressed: () async {
                  final isValid = _formKey.currentState!.validate();
                  if (isValid == false) return;

                  final passwordInput = passwordController.text;
                  final loggedIn = await ref.read(authServiceProvider).login(passwordInput);

                  if (!context.mounted) return;

                  if (loggedIn) {
                    Navigator.of(
                      context,
                    ).pushAndRemoveUntil(fadePageRouteBuilder(NotesPage()), (route) => false);
                  } else {
                    setState(() => errorText = AppLocalizations.of(context)!.wrongPasswordError);
                  }
                },
                child: Text(AppLocalizations.of(context)!.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
