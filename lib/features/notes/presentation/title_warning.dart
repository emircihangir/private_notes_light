import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/notes/application/title_warning_pref.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class TitleWarning extends ConsumerWidget {
  const TitleWarning({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.titleWarning),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: ref.read(titleWarningPrefProvider.notifier).dismiss,
                  child: Text(AppLocalizations.of(context)!.dismiss),
                ),
                TextButton(
                  onPressed: ref.read(titleWarningPrefProvider.notifier).dontShowAgain,
                  child: Text(AppLocalizations.of(context)!.dontShowAgain),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
