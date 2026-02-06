import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String passwordInput = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: .center,
          spacing: 32,
          children: [
            Text('Welcome', style: Theme.of(context).textTheme.headlineLarge),
            PasswordTextField(onChanged: (value) => passwordInput = value),
            FilledButton(onPressed: () {}, child: Text('Login')),
          ],
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final Function(String) onChanged;
  const PasswordTextField({super.key, required this.onChanged});

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
              decoration: InputDecoration(hintText: 'Password'),
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
