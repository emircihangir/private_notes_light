import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/settings/application/settings_controller.dart';
import 'package:private_notes_light/features/settings/presentation/help_button.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class ExportSuggestionsSwitchTile extends ConsumerWidget {
  const ExportSuggestionsSwitchTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsController = ref.watch(settingsControllerProvider);

    return settingsController.whenData((settingsData) {
          return SwitchListTile(
            title: Row(
              children: [
                Text(l10n.exportSuggestions),
                HelpButton(
                  helpTitle: l10n.exportSuggestions,
                  helpText: l10n.exportSuggestionsHelpText,
                ),
              ],
            ),
            value: settingsData.exportSuggestions,
            onChanged: (newValue) async =>
                await ref.read(settingsControllerProvider.notifier).setExportSuggestions(newValue),
          );
        }).valueOrNull ??
        const SizedBox();
  }
}
