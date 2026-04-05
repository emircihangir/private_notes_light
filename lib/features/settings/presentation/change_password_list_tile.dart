import 'package:flutter/material.dart';
import 'package:private_notes_light/features/settings/presentation/change_password_sheet.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class ChangePasswordListTile extends StatelessWidget {
  const ChangePasswordListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      leading: const Icon(Icons.key_outlined),
      title: Text(l10n.changePassword),
      subtitle: Text(l10n.changePasswordSubtitle),
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
