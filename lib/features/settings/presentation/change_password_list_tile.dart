import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/settings/presentation/change_password_sheet.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class ChangePasswordListTile extends ConsumerWidget {
  const ChangePasswordListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.key_outlined),
      title: Text(AppLocalizations.of(context)!.changePassword),
      subtitle: Text(AppLocalizations.of(context)!.changePasswordSubtitle),
      onTap: () async {
        await showModalBottomSheet(
          isScrollControlled: true,
          showDragHandle: true,
          context: context,
          builder: (context) => const ChangePasswordSheet(),
        );
      },
    );
  }
}
