import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final Function(String) onChanged;
  final String hintText;
  const PasswordTextField({super.key, required this.onChanged, this.hintText = 'Password'});

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
            child: TextField(
              onChanged: widget.onChanged,
              obscureText: isObscure,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(hintText: widget.hintText),
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
