import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/application/trashed_notes.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class TrashedNotesSheet extends ConsumerWidget {
  const TrashedNotesSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom + 32;
    final trashedNotes = ref.watch(trashedNotesProvider);

    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Center(
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.trashedNotes, style: textTheme.titleMedium),
            Text(l10n.trashedNotesExplainer, style: textTheme.labelMedium),
            Expanded(
              child: ListView.builder(
                itemCount: trashedNotes.length,
                itemBuilder: (context, index) {
                  final trashedNote = trashedNotes[index];
                  return ListTile(
                    title: Text(trashedNote.noteWidgetData.noteTitle),
                    trailing: TextButton(
                      onPressed: () => ref.read(noteControllerProvider.notifier).putNoteBack(trashedNote),
                      child: Text(l10n.putBack),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
