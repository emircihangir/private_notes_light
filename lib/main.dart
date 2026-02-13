import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/settings/application/settings_controller.dart';
import 'package:private_notes_light/features/authentication/presentation/auth_guard.dart';
import 'package:private_notes_light/core/theme.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);
    final themeMode = settingsAsync.valueOrNull?.theme ?? .system;

    return MaterialApp(
      themeMode: themeMode,
      theme: appTheme(.light),
      darkTheme: appTheme(.dark),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: AuthGuard(),
    );
  }
}
