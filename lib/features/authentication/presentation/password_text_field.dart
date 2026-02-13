import 'dart:developer';

import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  const PasswordTextField({super.key, required this.controller, this.hintText = 'Password'});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isObscure = true;

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
    log('Disposed the password text field controller.', name: 'INFO');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Row(
        children: [
          SizedBox(width: 48, height: 48),
          Expanded(
            child: TextField(
              controller: widget.controller,
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
