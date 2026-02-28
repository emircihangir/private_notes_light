import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/application/title_warning_pref.dart';
import 'package:private_notes_light/features/notes/domain/note.dart';
import 'package:private_notes_light/features/notes/domain/note_widget_data.dart';
import 'package:private_notes_light/features/notes/presentation/title_warning.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class EditNoteView extends ConsumerStatefulWidget {
  final Note note;
  final void Function(Note updatedNote) onCheckPressed;
  const EditNoteView({super.key, required this.note, required this.onCheckPressed});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends ConsumerState<EditNoteView> {
  late final TextEditingController titleInputController;
  late final TextEditingController contentInputController;
  final _formKey = GlobalKey<FormState>();
  late Note updatedNote;

  @override
  void initState() {
    super.initState();
    titleInputController = TextEditingController(text: widget.note.title);
    contentInputController = TextEditingController(text: widget.note.content);
    updatedNote = widget.note;
  }

  @override
  void dispose() {
    titleInputController.dispose();
    contentInputController.dispose();
    super.dispose();
  }

  // Handlers
  Future<void> handleSave() async {
    if (_formKey.currentState!.validate() == false) return;

    final noteControllerNotifier = ref.read(noteControllerProvider.notifier);

    updatedNote = widget.note.copyWith(
      title: titleInputController.text,
      content: contentInputController.text,
    );
    await noteControllerNotifier.createNote(
      id: updatedNote.id,
      title: updatedNote.title,
      content: updatedNote.content,
      date: updatedNote.dateCreated,
    );
  }

  void handleDeleteTap() {
    ref
        .read(noteControllerProvider.notifier)
        .moveNoteToTrash(NoteWidgetData(noteId: widget.note.id, noteTitle: widget.note.title));
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  InputDecoration inputDecoration() => InputDecoration(
    contentPadding: const EdgeInsets.all(16),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Theme.of(context).colorScheme.inversePrimary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(3),
      borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.inversePrimary),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Theme.of(context).colorScheme.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Theme.of(context).colorScheme.error),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final titleWarningPref = ref.watch(titleWarningPrefProvider);
    final showTitleWarning = (titleWarningPref.valueOrNull == true);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await handleSave();
            widget.onCheckPressed(updatedNote);
          },
          icon: Icon(Icons.check_rounded),
        ),
        title: Text(AppLocalizations.of(context)!.editNoteTitle),
        // actions: [DeleteNoteButton(widget.note.id, handleDeleteTap: handleDeleteTap)],
        actions: [IconButton(onPressed: handleDeleteTap, icon: const Icon(Icons.delete_rounded))],

        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 16,
                children: [
                  TextFormField(
                    decoration: inputDecoration().copyWith(
                      hintText: AppLocalizations.of(context)!.noteTitleLabel,
                      labelText: AppLocalizations.of(context)!.noteTitleLabel,
                    ),
                    controller: titleInputController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.titleEmptyError;
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  TextFormField(
                    decoration: inputDecoration().copyWith(
                      hintText: AppLocalizations.of(context)!.noteContentLabel,
                      labelText: AppLocalizations.of(context)!.noteContentLabel,
                    ),
                    maxLines: null,
                    controller: contentInputController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.contentEmptyError;
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  showTitleWarning ? TitleWarning() : SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
