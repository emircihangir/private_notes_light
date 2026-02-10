import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/backup/application/backup_service.dart';
import 'package:private_notes_light/features/settings/application/settings_controller.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsControllerAsync = ref.watch(settingsControllerProvider);

    return Scaffold(
      appBar: AppBar(automaticallyImplyActions: true, title: Text('Settings'), centerTitle: true),
      body: ListTileTheme(
        shape: Border(),
        child: ListView(
          children: [
            SectionHeader('Data Management'),
            ListTile(
              leading: const Icon(Icons.upload_rounded),
              title: const Text('Export Data'),
              subtitle: const Text('Save your notes to a local file'),
              onTap: () async {
                final exportResult = await ref.read(backupServiceProvider.notifier).export();
                if (context.mounted) {
                  if (exportResult == true) {
                    showExportSuccessfulSnackbar(context);
                  } else if (exportResult == null) {
                    showErrorSnackbar(context);
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.download_rounded),
              title: const Text('Import Data'),
              subtitle: const Text('Restore notes from a backup file'),
              onTap: () {},
            ),
            settingsControllerAsync.whenData((settingsState) {
                  return SwitchListTile(
                    title: Text('Export Suggestions'),
                    value: settingsState.exportSuggestions,
                    onChanged: (newValue) async => await ref
                        .read(settingsControllerProvider.notifier)
                        .setExportSuggestions(newValue),
                  );
                }).value ??
                ListTile(title: Text('Export Suggestions'), trailing: SizedBox()),

            settingsControllerAsync.whenData((settingsState) {
                  return SwitchListTile(
                    title: Text('Export Warnings'),
                    value: settingsState.exportWarnings,
                    onChanged: (newValue) async => await ref
                        .read(settingsControllerProvider.notifier)
                        .setExportWarnings(newValue),
                  );
                }).value ??
                ListTile(title: Text('Export Warnings'), trailing: SizedBox()),

            SectionHeader('Theme'),
            ListTile(title: BrightnessSegmentedButton()),

            SectionHeader('About'),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Source Code'),
              subtitle: Text('Available on GitHub'),
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () async {
                final result = await launchUrl(
                  Uri.parse("https://github.com/emircihangir/private_notes_light"),
                  mode: .externalApplication,
                );
                if (result == false && context.mounted) {
                  showErrorSnackbar(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback_rounded),
              title: const Text('Report Feedback'),
              subtitle: const Text('Contact via Email'),
              onTap: () async {
                final result = await launchUrl(
                  Uri.parse("mailto:m.emircihangir@gmail.com"),
                  mode: .externalApplication,
                );
                if (result == false && context.mounted) {
                  showErrorSnackbar(context);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.coffee),
              title: const Text('Support Development'),
              subtitle: const Text('Buy me a coffee'),
              onTap: () async {
                final result = await launchUrl(
                  Uri.parse("https://buymeacoffee.com/emircihangir"),
                  mode: .externalApplication,
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
                  Text('Private Notes Light', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0 • February 2026',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Developed by Muhammed Emir Cihangir',
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
                  ButtonSegment<Brightness>(
                    value: .light,
                    label: Text('Light'),
                    icon: Icon(Icons.light_mode_rounded),
                  ),
                  ButtonSegment(
                    value: null,
                    label: Text('System'),
                    icon: Icon(Icons.auto_mode_rounded),
                  ),
                  ButtonSegment<Brightness>(
                    value: .dark,
                    label: Text('Dark'),
                    icon: Icon(Icons.dark_mode_rounded),
                  ),
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
