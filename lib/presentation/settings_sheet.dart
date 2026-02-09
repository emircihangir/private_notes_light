import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/application/settings_controller.dart';

Widget settingsSheetBuilder(BuildContext context) {
  return ListTileTheme(
    shape: Border(),
    child: ListView(
      children: [
        ListTile(title: Text('Auto-Export'), trailing: AutoExportSwitch()),
        ListTile(title: Text('Theme'), trailing: BrightnessSegmentedButton()),
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
