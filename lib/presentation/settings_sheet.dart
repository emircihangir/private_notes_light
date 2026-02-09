import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/application/settings_controller.dart';
import 'package:private_notes_light/presentation/link_text.dart';

Widget settingsSheetBuilder(BuildContext context) {
  final textThemeOfContext = Theme.of(context).textTheme;

  return ListTileTheme(
    shape: Border(),
    child: ListView(
      children: [
        ListTile(title: Text('Settings', style: textThemeOfContext.headlineMedium)),
        ListTile(title: Text('Auto-Export'), trailing: AutoExportSwitch()),
        ListTile(title: Text('Theme'), trailing: BrightnessSegmentedButton()),
        ListTile(),
        ListTile(title: Text('Info', style: textThemeOfContext.headlineMedium)),
        ListTile(
          title: Text('Developed by'),
          trailing: Text('Muhammed Emir Cihangir', style: textThemeOfContext.bodyMedium),
        ),
        ListTile(
          title: Text('Release date'),
          trailing: Text('February 2026', style: textThemeOfContext.bodyMedium),
        ),
        ListTile(
          title: Text('Last updated'),
          trailing: Text('February 2026', style: textThemeOfContext.bodyMedium),
        ),
        ListTile(
          title: Text('Last updated'),
          trailing: Text('February 2026', style: textThemeOfContext.bodyMedium),
        ),
        ListTile(
          title: Text('Source code'),
          trailing: LinkText(
            url: "https://github.com/emircihangir/private_notes_light",
            urlText: "GitHub",
          ),
        ),
        ListTile(
          title: Text('My website'),
          trailing: LinkText(url: "https://www.emircihangir.com/", urlText: "emircihangir.com"),
        ),
        ListTile(
          title: Text('Contact me'),
          trailing: LinkText(url: "mailto:m.emircihangir@gmail.com", urlText: "E-mail"),
        ),
        ListTile(
          title: Text('Show support'),
          trailing: LinkText(
            url: "https://buymeacoffee.com/emircihangir",
            urlText: "Buy me a coffee",
          ),
        ),
      ],
    ),
  );
}

class AutoExportSwitch extends ConsumerWidget {
  const AutoExportSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsControllerAsync = ref.watch(settingsControllerProvider);

    return settingsControllerAsync.whenData((settingsState) {
          return Switch(
            value: settingsState.autoExport,
            onChanged: (value) =>
                ref.read(settingsControllerProvider.notifier).setAutoExport(value),
          );
        }).value ??
        SizedBox();
  }
}

class BrightnessSegmentedButton extends ConsumerWidget {
  const BrightnessSegmentedButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsControllerAsync = ref.watch(settingsControllerProvider);

    return settingsControllerAsync
            .whenData(
              (settingState) => SegmentedButton<Brightness?>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment<Brightness>(value: .light, label: Text('Light')),
                  ButtonSegment(value: null, label: Text('System')),
                  ButtonSegment<Brightness>(value: .dark, label: Text('Dark')),
                ],
                selected: <Brightness?>{settingState.brightness},
                onSelectionChanged: (Set<Brightness?> newSelectionSet) async {
                  final newSelection = newSelectionSet.first;
                  await ref.read(settingsControllerProvider.notifier).setBrightness(newSelection);
                },
              ),
            )
            .value ??
        SizedBox();
  }
}
