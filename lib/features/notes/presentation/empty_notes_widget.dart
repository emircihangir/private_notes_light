import 'package:flutter/material.dart';
import 'package:private_notes_light/features/notes/presentation/create_note_page.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class EmptyNotesWidget extends StatelessWidget {
  const EmptyNotesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          Text(
            AppLocalizations.of(context)!.noNotesTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => const CreateNotePage()));
            },
            child: Text(AppLocalizations.of(context)!.createNoteButton),
          ),
        ],
      ),
    );
  }
}
