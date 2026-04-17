import 'package:flutter/material.dart';
import 'package:private_notes_light/features/backup/presentation/export_list_tile.dart';
import 'package:private_notes_light/features/backup/presentation/import_list_tile.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:private_notes_light/features/settings/presentation/change_password_list_tile.dart';
import 'package:private_notes_light/features/settings/presentation/export_suggestions_switch_tile.dart';
import 'package:private_notes_light/features/settings/presentation/export_warnings_switch_tile.dart';
import 'package:private_notes_light/features/settings/presentation/note_sorting_dropdown_button.dart';
import 'package:private_notes_light/features/settings/presentation/section_header.dart';
import 'package:private_notes_light/features/settings/presentation/theme_dropdown_button.dart';
import 'package:private_notes_light/features/settings/presentation/version_text.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> openUrl(String urlText, BuildContext context) async {
    final result = await launchUrl(Uri.parse(urlText), mode: LaunchMode.externalApplication);
    if (result == false && context.mounted) {
      showErrorSnackbar(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    const sectionGap = 24.0;
    const linkIconSize = 20.0;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle), centerTitle: true),
      body: ListTileTheme(
        shape: const Border(),
        child: ListView(
          children: [
            SectionHeader(l10n.dataManagementSection),
            const ExportListTile(),
            const ImportListTile(),
            const ChangePasswordListTile(),
            const ExportSuggestionsSwitchTile(),
            const ExportWarningsSwitchTile(),

            const SizedBox(height: sectionGap),
            SectionHeader(l10n.appearance),
            ListTile(title: Text(l10n.themeSection), trailing: const ThemeDropdownButton()),
            ListTile(title: Text(l10n.noteSorting), trailing: const NoteSortingDropdownButton()),

            const SizedBox(height: sectionGap),
            SectionHeader(l10n.aboutSection),
            ListTile(
              leading: const Icon(Icons.code),
              title: Text(l10n.sourceCodeTitle),
              subtitle: Text(l10n.sourceCodeSubtitle),
              trailing: const Icon(Icons.open_in_new, size: linkIconSize),
              onTap: () async => await openUrl('https://github.com/emircihangir/private_notes_light', context),
            ),
            ListTile(
              leading: const Icon(Icons.article_rounded),
              title: Text(l10n.documentation),
              subtitle: Text(l10n.documentationSubtitle),
              trailing: const Icon(Icons.open_in_new, size: linkIconSize),
              onTap: () async => await openUrl('https://deepwiki.com/emircihangir/private_notes_light', context),
            ),
            ListTile(
              leading: const Icon(Icons.feedback_rounded),
              title: Text(l10n.reportFeedbackTitle),
              subtitle: Text(l10n.reportFeedbackSubtitle),
              onTap: () async => await openUrl('mailto:m.emircihangir@gmail.com', context),
            ),
            ListTile(
              leading: const Icon(Icons.coffee),
              title: Text(l10n.supportDevelopmentTitle),
              subtitle: Text(l10n.supportDevelopmentSubtitle),
              onTap: () async => await openUrl('https://buymeacoffee.com/emircihangir', context),
            ),

            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.appName, style: textTheme.titleMedium),
                  const SizedBox(height: 4),
                  VersionText(l10n: l10n, textTheme: textTheme),
                  Text(l10n.developedBy, style: textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
