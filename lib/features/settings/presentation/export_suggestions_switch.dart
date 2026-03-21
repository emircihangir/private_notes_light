import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/settings/application/settings_controller.dart';

class ExportSuggestionsSwitch extends ConsumerWidget {
  const ExportSuggestionsSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsControllerAsync = ref.watch(settingsControllerProvider);

    return settingsControllerAsync.whenData((settingsState) {
          return Switch(
            value: settingsState.exportSuggestions,
            onChanged: (value) async {
              await ref.read(settingsControllerProvider.notifier).setExportSuggestions(value);
            },
          );
        }).value ??
        const SizedBox();
  }
}
