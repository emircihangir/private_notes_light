import 'package:flutter/material.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final Function(String value)? onChanged;
  const PasswordTextField({
    super.key,
    required this.controller,
    this.hintText = 'Password',
    this.errorText,
    this.onChanged,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        children: [
          SizedBox(width: 48, height: 48),
          Expanded(
            child: TextFormField(
              onChanged: widget.onChanged,
              controller: widget.controller,
              obscureText: isObscure,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(hintText: widget.hintText, errorText: widget.errorText),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.passwordEmptyError;
                }
                return null;
              },
            ),
          ),
          IconButton(
            onPressed: () => setState(() => isObscure = !isObscure),
            icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
          ),
        ],
      ),
    );
  }
}
