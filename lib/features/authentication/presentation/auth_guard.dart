import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/authentication/application/user_signed_up.dart';
import 'package:private_notes_light/features/authentication/presentation/login_screen.dart';
import 'package:private_notes_light/features/authentication/presentation/signup_screen.dart';

class AuthGuard extends ConsumerWidget {
  const AuthGuard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSignedUp = ref.watch(userSignedUpProvider);

    return userSignedUp.whenData((isSignedUp) {
          if (isSignedUp) {
            return const LoginScreen();
          } else {
            return const SignupScreen();
          }
        }).valueOrNull ??
        const SizedBox();
  }
}
