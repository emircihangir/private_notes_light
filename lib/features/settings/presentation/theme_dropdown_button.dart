import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/settings/application/settings_controller.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class ThemeDropdownButton extends ConsumerWidget {
  const ThemeDropdownButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsController = ref.watch(settingsControllerProvider);
    const iconSize = 20.0;
    const rowSpacing = 8.0;

    return settingsController.whenData((settingsData) {
          return DropdownButtonHideUnderline(
            child: DropdownButton<ThemeMode>(
              alignment: const AlignmentGeometry.xy(0, 0),
              isExpanded: false,
              icon: const Icon(Icons.arrow_drop_down_rounded),
              items: [
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Row(
                    spacing: rowSpacing,
                    children: [
                      const Icon(Icons.light_mode_rounded, size: iconSize),
                      Text(l10n.themeLight),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Row(
                    spacing: rowSpacing,
                    children: [
                      const Icon(Icons.auto_mode_rounded, size: iconSize),
                      Text(l10n.themeSystem),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Row(
                    spacing: rowSpacing,
                    children: [
                      const Icon(Icons.dark_mode_rounded, size: iconSize),
                      Text(l10n.themeDark),
                    ],
                  ),
                ),
              ],
              value: settingsData.theme,
              onChanged: (value) async => await ref.read(settingsControllerProvider.notifier).setTheme(value!),
            ),
          );
        }).valueOrNull ??
        const SizedBox();
  }
}
