import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/application/note_controller.dart';
import 'package:private_notes_light/domain/note.dart';
import 'package:private_notes_light/presentation/snackbars.dart';

class CreateNotePage extends ConsumerStatefulWidget {
  final Note? note;
  const CreateNotePage({super.key, this.note});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends ConsumerState<CreateNotePage> {
  late final TextEditingController titleInputController;
  late final TextEditingController contentInputController;

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      titleInputController = TextEditingController(text: widget.note!.title);
      contentInputController = TextEditingController(text: widget.note!.content);
    } else {
      titleInputController = TextEditingController(text: '');
      contentInputController = TextEditingController(text: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Note'), centerTitle: false),
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
}
