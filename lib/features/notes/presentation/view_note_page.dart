import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleInputController = TextEditingController(text: widget.note?.title ?? '');
    contentInputController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    titleInputController.dispose();
    contentInputController.dispose();
    super.dispose();
  }

  // Handlers
  Future<void> handleSaveTap() async {
    if (_formKey.currentState!.validate() == false) return;

    final noteControllerNotifier = ref.read(noteControllerProvider.notifier);
    await noteControllerNotifier.createNote(
      id: widget.note?.id,
      title: titleInputController.text,
      content: contentInputController.text,
      date: widget.note?.dateCreated,
    );

    if (mounted) Navigator.of(context).pop();
  }

  Future<void> handleDeleteTap(String noteId) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const ConfirmDeleteDialog(),
    );

    if (result == true) {
      await ref.read(noteControllerProvider.notifier).removeNote(noteId);
      if (mounted) Navigator.of(context).pop();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note == null
              ? AppLocalizations.of(context)!.createNoteTitle
              : AppLocalizations.of(context)!.editNoteTitle,
        ),
        actions: widget.note != null
            ? [DeleteNoteButton(widget.note!.id, handleDeleteTap: handleDeleteTap)]
            : null,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
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
                    autofocus: widget.note == null,
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
                  FilledButton(
                    onPressed: handleSaveTap,
                    child: Text(AppLocalizations.of(context)!.save),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteNoteButton extends StatelessWidget {
  final String noteId;
  final Function(String noteId) handleDeleteTap;
  const DeleteNoteButton(this.noteId, {super.key, required this.handleDeleteTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => handleDeleteTap(noteId),
      icon: const Icon(Icons.delete_rounded),
    );
  }
}
