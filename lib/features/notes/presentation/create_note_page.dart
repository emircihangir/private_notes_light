import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/application/title_warning_pref.dart';
import 'package:private_notes_light/features/notes/presentation/title_warning.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class CreateNotePage extends ConsumerStatefulWidget {
  const CreateNotePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends ConsumerState<CreateNotePage> {
  final TextEditingController titleInputController = TextEditingController();
  final TextEditingController contentInputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleInputController.dispose();
    contentInputController.dispose();
    super.dispose();

    log('Disposed the password text field controllers in CreateNotePage.', name: 'INFO');
  }

  // Handlers
  Future<void> handleSave() async {
    if (_formKey.currentState!.validate() == false) return;

    final noteControllerNotifier = ref.read(noteControllerProvider.notifier);
    await noteControllerNotifier.createNote(
      title: titleInputController.text,
      content: contentInputController.text,
    );
    if (mounted) Navigator.of(context).pop();
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
        automaticallyImplyLeading: true,
        title: Text(AppLocalizations.of(context)!.createNoteTitle),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () async => await handleSave(), icon: Icon(Icons.check_rounded)),
        ],
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
                    autofocus: true,
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
