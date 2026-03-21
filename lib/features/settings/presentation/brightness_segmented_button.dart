import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/settings/application/settings_controller.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class BrightnessSegmentedButton extends ConsumerWidget {
  const BrightnessSegmentedButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsControllerAsync = ref.watch(settingsControllerProvider);

    return settingsControllerAsync
            .whenData(
              (settingData) => SegmentedButton<ThemeMode>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.light,
                    label: Text(AppLocalizations.of(context)!.themeLight),
                    icon: const Icon(Icons.light_mode_rounded),
                  ),
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text(AppLocalizations.of(context)!.themeSystem),
                    icon: const Icon(Icons.auto_mode_rounded),
                  ),
                  ButtonSegment<ThemeMode>(
                    value: ThemeMode.dark,
                    label: Text(AppLocalizations.of(context)!.themeDark),
                    icon: const Icon(Icons.dark_mode_rounded),
                  ),
                ],
                selected: <ThemeMode>{settingData.theme},
                onSelectionChanged: (Set<ThemeMode> newSelectionSet) async {
                  final newSelection = newSelectionSet.first;
                  await ref.read(settingsControllerProvider.notifier).setTheme(newSelection);
                },
              ),
            )
            .value ??
        const SizedBox();
  }
}
