import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/domain/note.dart';
import 'package:private_notes_light/core/snackbars.dart';

class ViewNotePage extends ConsumerStatefulWidget {
  final Note? note;
  const ViewNotePage({super.key, this.note});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewNotePageState();
}

class _ViewNotePageState extends ConsumerState<ViewNotePage> {
  late final TextEditingController titleInputController;
  late final TextEditingController contentInputController;

  @override
  void initState() {
    super.initState();

    titleInputController = TextEditingController(text: widget.note?.title ?? '');
    contentInputController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Create Note' : 'Edit Note'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            padding: EdgeInsets.only(top: 16),
            child: Column(
              spacing: 16,
              children: [
                TextField(
                  decoration: InputDecoration(hintText: 'Title'),
                  controller: titleInputController,
                  textInputAction: .next,
                  autofocus: widget.note == null,
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Content'),
                  maxLines: null,
                  controller: contentInputController,
                ),
                FilledButton(
                  onPressed: () async {
                    if (titleInputController.text.isEmpty) {
                      showEmptyInputSnackbar(context, inputName: 'Title');
                      return;
                    }
                    if (contentInputController.text.isEmpty) {
                      showEmptyInputSnackbar(context, inputName: 'Content');
                      return;
                    }

                    await ref
                        .read(noteControllerProvider.notifier)
                        .createNote(
                          id: widget.note?.id,
                          title: titleInputController.text,
                          content: contentInputController.text,
                          date: widget.note?.dateCreated,
                        );

                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleInputController.dispose();
    contentInputController.dispose();

    super.dispose();
  }
}
