import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/application/app_startup.dart';
import 'package:private_notes_light/presentation/generic_error_widget.dart';
import 'package:private_notes_light/presentation/login_screen.dart';
import 'package:private_notes_light/presentation/signup_screen.dart';

class AuthGuard extends ConsumerWidget {
  const AuthGuard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartup = ref.watch(appStartupProvider);

    return appStartup.when(
      data: (data) {
        if (data) {
          return LoginScreen();
        } else {
          return SignupScreen();
        }
      },
      error: (error, stackTrace) => GenericErrorWidget(),
      loading: () => CircularProgressIndicator(),
    );
  }
}
