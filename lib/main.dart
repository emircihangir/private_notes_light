import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/application/settings_controller.dart';
import 'package:private_notes_light/presentation/auth_guard.dart';
import 'package:private_notes_light/presentation/theme.dart';

void main() {
  runApp(ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsControllerProvider);

    late final ThemeMode themeMode;
    final brightness = settingsAsync.valueOrNull?.brightness;

    if (brightness == .light) {
      themeMode = .light;
    } else if (brightness == .dark) {
      themeMode = .dark;
    } else {
      // brightness is null. Saved settings is loading.
      // Default to system theme.
      themeMode = .system;
    }

    return MaterialApp(
      themeMode: themeMode,
      theme: appTheme(.light),
      darkTheme: appTheme(.dark),
      home: AuthGuard(),
    );
  }
}
