import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/core/fade_page_route_builder.dart';
import 'package:private_notes_light/features/authentication/application/auth_service.dart';
import 'package:private_notes_light/features/notes/presentation/notes_page.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';
import 'package:private_notes_light/shared/utils/trigger_import_flow.dart';

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
    log('Disposed the password text field controllers in signup screen.', name: 'INFO');
  }

  Future<void> _submitForm(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await ref.read(authServiceProvider).signup(controller2.text);
    } catch (e) {
      if (!mounted) return;
      showErrorSnackbar(context, content: l10n.signupGenericError);
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(fadePageRouteBuilder(const NotesPage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  const Spacer(),
                  Text(l10n.welcome, style: textTheme.headlineLarge),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(l10n.masterPasswordSetupWarning, textAlign: .justify),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: controller1,
                    decoration: InputDecoration(labelText: l10n.password),
                    textInputAction: .next,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return l10n.passwordEmptyError;
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller2,
                    decoration: InputDecoration(labelText: l10n.confirmPassword),
                    textInputAction: .done,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) return l10n.passwordEmptyError;
                      if (value != controller1.text) return l10n.passwordsDontMatch;
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  FilledButton(onPressed: () => _submitForm(l10n), child: Text(l10n.signupButton)),
                  const Spacer(),
                  Column(
                    children: [
                      Text(l10n.signupBackupPrompt),
                      TextButton(
                        onPressed: () async {
                          await triggerImportFlow(
                            context,
                            ref,
                            onSuccessfulImport: () {
                              final routeBuilder = fadePageRouteBuilder(const NotesPage());
                              Navigator.of(context).pushAndRemoveUntil(routeBuilder, (route) => false);
                              showSuccessSnackbar(context, content: l10n.importSuccess);
                            },
                          );
                        },
                        child: Text(l10n.importBackupButton),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
