import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/application/note_controller.dart';
import 'package:private_notes_light/presentation/snackbars.dart';

class CreateNotePage extends ConsumerStatefulWidget {
  const CreateNotePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends ConsumerState<CreateNotePage> {
  String titleInput = '';
  String contentInput = '';

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
                  onChanged: (value) => titleInput = value,
                  textInputAction: .next,
                  autofocus: true,
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Content'),
                  maxLines: null,
                  onChanged: (value) => contentInput = value,
                ),
                FilledButton(
                  onPressed: () async {
                    if (titleInput.isEmpty) {
                      showEmptyInputSnackbar(context, inputName: 'Title');
                      return;
                    }
                    if (contentInput.isEmpty) {
                      showEmptyInputSnackbar(context, inputName: 'Content');
                      return;
                    }

                    await ref
                        .read(noteControllerProvider.notifier)
                        .createNote(title: titleInput, content: contentInput);

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
