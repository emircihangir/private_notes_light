import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:private_notes_light/features/backup/application/backup_service.dart';

class ExportListTile extends ConsumerWidget {
  const ExportListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void triggerExport() async {
      try {
        await ref.read(backupServiceProvider.notifier).export();
        if (context.mounted) showSuccessSnackbar(context, 'Export Successful.');
      } catch (e) {
        if (context.mounted) showErrorSnackbar(context);
      }
    }

    return ListTile(
      leading: const Icon(Icons.upload_rounded),
      title: const Text('Export Data'),
      subtitle: const Text('Save your notes to a local file'),
      onTap: triggerExport,
    );
  }
}
