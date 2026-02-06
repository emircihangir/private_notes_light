import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/presentation/password_text_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                'Please set up a master password. Be careful, there is no way to unlock your notes without the master password.',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            PasswordTextField(
              onChanged: (value) => passwordInput = value,
              hintText: 'Master Password',
            ),
            FilledButton(onPressed: () {}, child: Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
