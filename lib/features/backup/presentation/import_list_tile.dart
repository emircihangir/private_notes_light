import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';
import 'package:private_notes_light/shared/utils/trigger_import_flow.dart';

class ImportListTile extends ConsumerWidget {
  const ImportListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      key: const ValueKey('ImportListTile'),
      leading: const Icon(Icons.download_rounded),
      title: Text(l10n.importDataTitle),
      subtitle: Text(l10n.importDataSubtitle),
      onTap: () async {
        await triggerImportFlow(
          context,
          ref,
          onSuccessfulImport: () {
            Navigator.of(context).pop();
            showSuccessSnackbar(context, content: l10n.importSuccess);
          },
        );
      },
    );
  }
}
