import 'package:flutter/material.dart';
import 'package:private_notes_light/features/notes/domain/note_widget_data.dart';

class NotesList extends StatelessWidget {
  final List<NoteWidgetData> filteredNotes;
  final void Function(DismissDirection, NoteWidgetData) onDismissed;
  final Future<void> Function(NoteWidgetData) onTap;

  const NotesList({
    super.key,
    required this.filteredNotes,
    required this.onDismissed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) {
          final NoteWidgetData noteWidgetData = filteredNotes[index];

          return Dismissible(
            onDismissed: (direction) => onDismissed(direction, noteWidgetData),
            key: ValueKey(noteWidgetData.noteId),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Theme.of(context).colorScheme.errorContainer,
              padding: const EdgeInsets.only(right: 8),
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.clear_rounded,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
            child: ListTile(
              title: Text(noteWidgetData.noteTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
              onTap: () => onTap(noteWidgetData),
            ),
          );
        },
      ),
    );
  }
}
