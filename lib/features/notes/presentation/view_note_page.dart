import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/notes/domain/note.dart';
import 'package:private_notes_light/features/notes/domain/view_mode.dart';
import 'package:private_notes_light/features/notes/presentation/edit_note_view.dart';
import 'package:private_notes_light/features/notes/presentation/view_note_view.dart';

class ViewNotePage extends ConsumerStatefulWidget {
  final Note note;
  const ViewNotePage({super.key, required this.note});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewNotePage();
}

class _ViewNotePage extends ConsumerState<ViewNotePage> {
  ViewMode _viewMode = ViewMode.view;
  late Note noteLatestVersion;

  @override
  void initState() {
    super.initState();
    noteLatestVersion = widget.note;
  }

  @override
  Widget build(BuildContext context) {
    return _viewMode == ViewMode.view
        ? ViewNoteView(
            note: noteLatestVersion,
            onEditPressed: () => setState(() => _viewMode = _viewMode.next),
          )
        : EditNoteView(
            note: widget.note,
            onCheckPressed: (updatedNote) => setState(() {
              noteLatestVersion = updatedNote;
              _viewMode = _viewMode.next;
            }),
          );
  }
}
