import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/backup/presentation/export_list_tile.dart';
import 'package:private_notes_light/features/backup/presentation/import_list_tile.dart';
import 'package:private_notes_light/features/settings/application/settings_controller.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsControllerAsync = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyActions: true,
        title: Text(AppLocalizations.of(context)!.settingsTitle),
        centerTitle: true,
      ),
      body: ListTileTheme(
        shape: const Border(),
        child: ListView(
          children: [
            SectionHeader(AppLocalizations.of(context)!.dataManagementSection),
            const ExportListTile(),
            const ImportListTile(),
            settingsControllerAsync.whenData((settingsData) {
                  return SwitchListTile(
                    title: Text(AppLocalizations.of(context)!.exportSuggestions),
                    value: settingsData.exportSuggestions,
                    onChanged: (newValue) async => await ref
                        .read(settingsControllerProvider.notifier)
                        .setExportSuggestions(newValue),
                  );
                }).value ??
                ListTile(
                  title: Text(AppLocalizations.of(context)!.exportSuggestions),
                  trailing: const SizedBox(),
                ),

            settingsControllerAsync.whenData((settingsState) {
                  return SwitchListTile(
                    title: Text(AppLocalizations.of(context)!.exportWarnings),
                    value: settingsState.exportWarnings,
                    onChanged: (newValue) async => await ref
                        .read(settingsControllerProvider.notifier)
                        .setExportWarnings(newValue),
                  );
                }).value ??
                ListTile(
                  title: Text(AppLocalizations.of(context)!.exportWarnings),
                  trailing: const SizedBox(),
                ),

            SectionHeader(AppLocalizations.of(context)!.themeSection),
            const ListTile(title: BrightnessSegmentedButton()),

            SectionHeader(AppLocalizations.of(context)!.aboutSection),
            ListTile(
              leading: const Icon(Icons.code),
              title: Text(AppLocalizations.of(context)!.sourceCodeTitle),
              subtitle: Text(AppLocalizations.of(context)!.sourceCodeSubtitle),
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () async {
                final result = await launchUrl(
                  Uri.parse("https://github.com/emircihangir/private_notes_light"),
                  mode: LaunchMode.externalApplication,
                );
                if (result == false && context.mounted) {
                  showErrorSnackbar(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback_rounded),
              title: Text(AppLocalizations.of(context)!.reportFeedbackTitle),
              subtitle: Text(AppLocalizations.of(context)!.reportFeedbackSubtitle),
              onTap: () async {
                final result = await launchUrl(
                  Uri.parse("mailto:m.emircihangir@gmail.com"),
                  mode: LaunchMode.externalApplication,
                );
                if (result == false && context.mounted) {
                  showErrorSnackbar(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.coffee),
              title: Text(AppLocalizations.of(context)!.supportDevelopmentTitle),
              subtitle: Text(AppLocalizations.of(context)!.supportDevelopmentSubtitle),
              onTap: () async {
                final result = await launchUrl(
                  Uri.parse("https://buymeacoffee.com/emircihangir"),
                  mode: LaunchMode.externalApplication,
                );
                if (result == false && context.mounted) {
                  showErrorSnackbar(context);
                }
              },
            ),

            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.appName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.appVersionInfo,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    AppLocalizations.of(context)!.developedBy,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String text;
  const SectionHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

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
