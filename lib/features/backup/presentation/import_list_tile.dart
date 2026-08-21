import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/backup/application/import_controller.dart';
import 'package:private_notes_light/features/backup/presentation/import_controller_listener.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class ImportListTile extends ConsumerWidget {
  const ImportListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ImportControllerListener(
      onSuccess: Navigator.of(context).pop,
      child: ListTile(
        key: const ValueKey('ImportListTile'),
        leading: const Icon(Icons.download_rounded),
        title: Text(l10n.importDataTitle),
        subtitle: Text(l10n.importDataSubtitle),
        onTap: () async =>
            await ref.read(importControllerProvider.notifier).startImport(dialogTitle: l10n.importSelectBackupTitle),
      ),
    );
  }
}
