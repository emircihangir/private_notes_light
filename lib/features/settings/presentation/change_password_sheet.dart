import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:private_notes_light/features/authentication/application/auth_service.dart';
import 'package:private_notes_light/features/authentication/presentation/password_text_field.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class ChangePasswordSheet extends ConsumerStatefulWidget {
  const ChangePasswordSheet({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends ConsumerState<ChangePasswordSheet> {
  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  String? errorText2;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
    log('Disposed the text field controllers in ChangePasswordSheet');
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom + 32;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: .min,
              spacing: 16,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    AppLocalizations.of(context)!.newPasswordWarning,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                PasswordTextField(
                  controller: controller1,
                  canBeToggled: false,
                  hintText: AppLocalizations.of(context)!.newPassword,
                  autoFocus: true,
                  textInputAction: .next,
                ),
                PasswordTextField(
                  controller: controller2,
                  canBeToggled: false,
                  hintText: AppLocalizations.of(context)!.newPasswordConfirm,
                  errorText: errorText2,
                ),
                FilledButton(
                  onPressed: () async {
                    final isValid = _formKey.currentState!.validate();
                    if (isValid == false) return;

                    if (controller1.text != controller2.text) {
                      setState(() {
                        errorText2 = AppLocalizations.of(context)!.passwordsDontMatch;
                      });
                      return;
                    } else if (errorText2 != null) {
                      setState(() => errorText2 = null);
                    }

                    await ref
                        .read(authServiceProvider.notifier)
                        .changeMasterPassword(controller1.text);

                    if (context.mounted) {
                      showSuccessSnackbar(
                        context,
                        content: AppLocalizations.of(context)!.changedPasswordSuccessfully,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.submitButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
