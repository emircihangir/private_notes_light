import 'package:flutter/material.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;
  final Function(String value)? onChanged;
  final bool canBeToggled;
  final bool autoFocus;
  final TextInputAction textInputAction;
  final String? labelText;
  const PasswordTextField({
    super.key,
    required this.controller,
    this.errorText,
    this.onChanged,
    this.canBeToggled = true,
    this.autoFocus = false,
    this.textInputAction = TextInputAction.done,
    this.labelText,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.autoFocus,
      onChanged: widget.onChanged,
      controller: widget.controller,
      obscureText: isObscure,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        errorText: widget.errorText,
        labelText: widget.labelText,
        suffixIcon: widget.canBeToggled
            ? IconButton(
                onPressed: () => setState(() => isObscure = !isObscure),
                icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
              )
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.passwordEmptyError;
        }
        return null;
      },
    );
  }
}
