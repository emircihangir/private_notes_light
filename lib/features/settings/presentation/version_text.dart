import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/settings/application/app_version.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class VersionText extends ConsumerWidget {
  final AppLocalizations l10n;
  final TextTheme textTheme;

  const VersionText({super.key, required this.l10n, required this.textTheme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appVersion = ref.watch(appVersionProvider);
    final String versionNumber = appVersion.valueOrNull ?? '';

    return Text('${l10n.version} $versionNumber', style: textTheme.bodySmall);
  }
}
