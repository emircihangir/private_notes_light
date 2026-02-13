import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/domain/note.dart';
import 'package:private_notes_light/features/notes/presentation/confirm_delete_dialog.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

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
        title: Text(
          widget.note == null
              ? AppLocalizations.of(context)!.createNoteTitle
              : AppLocalizations.of(context)!.editNoteTitle,
        ),
        actions: widget.note != null ? [DeleteNoteButton(widget.note!.id)] : null,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              spacing: 16,
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.noteTitleLabel,
                    labelText: AppLocalizations.of(context)!.noteTitleLabel,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  controller: titleInputController,
                  textInputAction: TextInputAction.next,
                  autofocus: widget.note == null,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.noteContentLabel,
                    labelText: AppLocalizations.of(context)!.noteContentLabel,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  maxLines: null,
                  controller: contentInputController,
                ),
                FilledButton(
                  onPressed: () async {
                    if (titleInputController.text.isEmpty) {
                      showErrorSnackbar(
                        context,
                        content: AppLocalizations.of(context)!.titleEmptyError,
                      );
                      return;
                    }
                    if (contentInputController.text.isEmpty) {
                      showErrorSnackbar(
                        context,
                        content: AppLocalizations.of(context)!.contentEmptyError,
                      );
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
                  child: Text(AppLocalizations.of(context)!.save),
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

class DeleteNoteButton extends ConsumerWidget {
  final String noteID;
  const DeleteNoteButton(this.noteID, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      onPressed: () async {
        final result = await showDialog<bool>(
          context: context,
          builder: (_) => const ConfirmDeleteDialog(),
        );

        if (result == true) {
          await ref.read(noteControllerProvider.notifier).removeNote(noteID);
          if (context.mounted) Navigator.of(context).pop();
        }
      },
      icon: const Icon(Icons.delete_rounded),
    );
  }
}
