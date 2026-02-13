import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:private_notes_light/features/backup/application/backup_service.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class ExportListTile extends ConsumerWidget {
  const ExportListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void triggerExport() async {
      try {
        final exportResult = await ref.read(backupServiceProvider.notifier).export();
        if (exportResult == true && context.mounted) {
          showSuccessSnackbar(context, content: AppLocalizations.of(context)!.exportSuccess);
        }
      } catch (e) {
        if (context.mounted) showErrorSnackbar(context);
      }
    }

    return ListTile(
      leading: const Icon(Icons.upload_rounded),
      title: Text(AppLocalizations.of(context)!.exportDataTitle),
      subtitle: Text(AppLocalizations.of(context)!.exportDataSubtitle),
      onTap: triggerExport,
    );
  }
}
