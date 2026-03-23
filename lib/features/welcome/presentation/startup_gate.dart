import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/core/generic_error_widget.dart';
import 'package:private_notes_light/features/authentication/presentation/auth_guard.dart';
import 'package:private_notes_light/features/welcome/application/welcome_shown.dart';
import 'package:private_notes_light/features/welcome/presentation/welcome_page.dart';

class StartupGate extends ConsumerWidget {
  /// Returns WelcomePage() if it is a first time user,
  /// AuthGuard() otherwise.
  const StartupGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final welcomeShown = ref.watch(welcomeShownProvider);

    return welcomeShown.when(
      data: (isShown) {
        if (isShown) {
          return const AuthGuard();
        } else {
          return const WelcomePage();
        }
      },
      error: (error, stackTrace) => const GenericErrorWidget(),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
