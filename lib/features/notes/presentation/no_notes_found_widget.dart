import 'package:flutter/material.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class NoNotesFoundWidget extends StatelessWidget {
  const NoNotesFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Center(child: Text(AppLocalizations.of(context)!.noNotesFound)));
  }
}
