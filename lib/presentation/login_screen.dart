import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/presentation/password_text_field.dart';

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
