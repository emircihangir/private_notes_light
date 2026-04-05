import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:private_notes_light/features/backup/application/export_service.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class ExportListTile extends ConsumerWidget {
  const ExportListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    void triggerExport() async {
      try {
        final exportResult = await ref.read(exportServiceProvider.future);
        if (exportResult == true && context.mounted) {
          showSuccessSnackbar(context, content: l10n.exportSuccess);
        }
      } catch (e) {
        if (context.mounted) showErrorSnackbar(context);
      }
    }

    return ListTile(
      key: const ValueKey('ExportListTile'),
      leading: const Icon(Icons.upload_rounded),
      title: Text(l10n.exportDataTitle),
      subtitle: Text(l10n.exportDataSubtitle),
      onTap: triggerExport,
    );
  }
}
