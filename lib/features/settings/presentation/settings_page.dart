import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/backup/presentation/export_list_tile.dart';
import 'package:private_notes_light/features/backup/presentation/import_list_tile.dart';
import 'package:private_notes_light/features/settings/application/app_version.dart';
import 'package:private_notes_light/features/settings/application/settings_controller.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:private_notes_light/features/settings/presentation/brightness_segmented_button.dart';
import 'package:private_notes_light/features/settings/presentation/change_password_list_tile.dart';
import 'package:private_notes_light/features/settings/presentation/help_button.dart';
import 'package:private_notes_light/features/settings/presentation/section_header.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsControllerAsync = ref.watch(settingsControllerProvider);
    final appVersion = ref.watch(appVersionProvider);
    final String versionNumber = appVersion.valueOrNull ?? '';
    final l10n = AppLocalizations.of(context)!;

    Future<void> openUrl(String urlText) async {
      final result = await launchUrl(Uri.parse(urlText), mode: LaunchMode.externalApplication);
      if (result == false && context.mounted) {
        showErrorSnackbar(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyActions: true,
        title: Text(l10n.settingsTitle),
        centerTitle: true,
      ),
      body: ListTileTheme(
        shape: const Border(),
        child: ListView(
          children: [
            SectionHeader(l10n.dataManagementSection),
            const ExportListTile(),
            const ImportListTile(),
            const ChangePasswordListTile(),
            settingsControllerAsync.whenData((settingsData) {
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
                    onChanged: (newValue) async => await ref
                        .read(settingsControllerProvider.notifier)
                        .setExportSuggestions(newValue),
                  );
                }).value ??
                ListTile(title: Text(l10n.exportSuggestions), trailing: const SizedBox()),
            settingsControllerAsync.whenData((settingsState) {
                  return SwitchListTile(
                    title: Row(
                      children: [
                        Text(l10n.exportWarnings),
                        HelpButton(
                          helpTitle: l10n.exportWarnings,
                          helpText: l10n.exportWarningsHelpText,
                        ),
                      ],
                    ),
                    value: settingsState.exportWarnings,
                    onChanged: (newValue) async => await ref
                        .read(settingsControllerProvider.notifier)
                        .setExportWarnings(newValue),
                  );
                }).value ??
                ListTile(title: Text(l10n.exportWarnings), trailing: const SizedBox()),

            SectionHeader(l10n.themeSection),
            const ListTile(title: BrightnessSegmentedButton()),

            SectionHeader(l10n.aboutSection),
            ListTile(
              leading: const Icon(Icons.code),
              title: Text(l10n.sourceCodeTitle),
              subtitle: Text(l10n.sourceCodeSubtitle),
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () async =>
                  await openUrl('https://github.com/emircihangir/private_notes_light'),
            ),
            ListTile(
              leading: const Icon(Icons.article_rounded),
              title: Text(l10n.documentation),
              subtitle: Text(l10n.documentationSubtitle),
              trailing: const Icon(Icons.open_in_new, size: 16),
              onTap: () async =>
                  await openUrl('https://deepwiki.com/emircihangir/private_notes_light'),
            ),
            ListTile(
              leading: const Icon(Icons.feedback_rounded),
              title: Text(l10n.reportFeedbackTitle),
              subtitle: Text(l10n.reportFeedbackSubtitle),
              onTap: () async => await openUrl('mailto:m.emircihangir@gmail.com'),
            ),
            ListTile(
              leading: const Icon(Icons.coffee),
              title: Text(l10n.supportDevelopmentTitle),
              subtitle: Text(l10n.supportDevelopmentSubtitle),
              onTap: () async => await openUrl('https://buymeacoffee.com/emircihangir'),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.appName, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.version} $versionNumber',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(l10n.developedBy, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
