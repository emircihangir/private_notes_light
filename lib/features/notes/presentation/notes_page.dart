import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/core/fade_page_route_builder.dart';
import 'package:private_notes_light/features/authentication/application/auth_service.dart';
import 'package:private_notes_light/features/backup/application/export_service.dart';
import 'package:private_notes_light/features/backup/application/file_picker_running.dart';
import 'package:private_notes_light/features/notes/application/filtered_notes_list.dart';
import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/application/search_query.dart';
import 'package:private_notes_light/features/authentication/presentation/login_screen.dart';
import 'package:private_notes_light/features/notes/domain/note_widget_data.dart';
import 'package:private_notes_light/features/notes/presentation/confirm_delete_dialog.dart';
import 'package:private_notes_light/features/settings/presentation/settings_page.dart';
import 'package:private_notes_light/features/notes/presentation/view_note_page.dart';
import 'package:private_notes_light/core/generic_error_widget.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> with WidgetsBindingObserver {
  bool logoutOnResume = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final filePickerRunning = ref.watch(filePickerRunningProvider);

    if ((state == AppLifecycleState.inactive) && !filePickerRunning) {
      log('The app lost focus. Logging out.', name: 'INFO');
      logoutOnResume = true;
      ref.read(authServiceProvider).logout();
    }

    if (state == AppLifecycleState.resumed && logoutOnResume) {
      log('Forcing the user to login again.', name: 'INFO');
      Navigator.of(
        context,
      ).pushAndRemoveUntil(fadePageRouteBuilder(LoginScreen()), (route) => false);
      showInfoSnackbar(context, content: AppLocalizations.of(context)!.sessionExpiredMessage);
      logoutOnResume = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Side effects
    Future<void> suggestExportIfPreferred() async {
      final exportSuggestionPreferred = await ref
          .read(noteControllerProvider.notifier)
          .getExportSuggestionPref();
      if (!context.mounted) return;
      if (exportSuggestionPreferred) {
        showExportSuggestionSnackbar(
          context,
          () async => await ref.watch(exportServiceProvider.future),
        );
      }
    }

    // Handlers
    void handleDismiss(DismissDirection direction, NoteWidgetData note) async {
      try {
        await ref.read(noteControllerProvider.notifier).removeNote(note.noteId);
        suggestExportIfPreferred();
      } catch (e) {
        if (context.mounted) showErrorSnackbar(context);
      }
    }

    Future<bool> handleConfirmDismiss(DismissDirection direction) async {
      final bool? shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => const ConfirmDeleteDialog(),
      );
      return shouldDelete ?? false;
    }

    void handleNoteWidgetTap(NoteWidgetData noteWidgetData) async {
      final result = await ref
          .read(noteControllerProvider.notifier)
          .openNote(noteWidgetData.noteId);
      if (context.mounted) {
        final madeChanges = await Navigator.of(
          context,
        ).push(MaterialPageRoute<bool>(builder: (context) => ViewNotePage(note: result)));
        if (madeChanges == true) suggestExportIfPreferred();
      }
    }

    final filteredNotes = ref.watch(filteredNotesListProvider);
    final fullNotesList = ref.watch(noteControllerProvider);

    // Widgets
    Widget notesList() => Expanded(
      child: ListView.builder(
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) {
          final NoteWidgetData noteWidgetData = filteredNotes[index];

          return Dismissible(
            onDismissed: (direction) => handleDismiss(direction, noteWidgetData),
            confirmDismiss: handleConfirmDismiss,
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
              title: Text(noteWidgetData.noteTitle),
              onTap: () => handleNoteWidgetTap(noteWidgetData),
            ),
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notesTitle),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            ref.read(authServiceProvider).logout();
            Navigator.of(
              context,
            ).pushAndRemoveUntil(fadePageRouteBuilder(LoginScreen()), (route) => false);
          },
          icon: const Icon(Icons.logout_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => const SettingsPage())),
            icon: const Icon(Icons.settings_outlined),
          ),
          IconButton(
            onPressed: () async {
              final madeChanges = await Navigator.of(
                context,
              ).push(MaterialPageRoute<bool>(builder: (context) => ViewNotePage()));
              if (madeChanges == true) suggestExportIfPreferred();
            },
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: fullNotesList.when(
          error: (error, stackTrace) {
            log('', error: error, stackTrace: stackTrace, name: 'ERROR');
            return const Center(child: GenericErrorWidget());
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (data) => Padding(
            padding: const EdgeInsets.all(12),
            child: data.isNotEmpty
                ? Column(
                    children: [
                      SearchBar(
                        leading: const Icon(Icons.search),
                        hintText: AppLocalizations.of(context)!.searchHint,
                        onChanged: (value) => ref.read(searchQueryProvider.notifier).set(value),
                      ),
                      filteredNotes.isNotEmpty ? notesList() : NoNotesFoundWidget(),
                    ],
                  )
                : EmptyNotesWidget(),
          ),
        ),
      ),
    );
  }
}

class NoNotesFoundWidget extends StatelessWidget {
  const NoNotesFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Center(child: Text(AppLocalizations.of(context)!.noNotesFound)));
  }
}

class EmptyNotesWidget extends StatelessWidget {
  const EmptyNotesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          Text(
            AppLocalizations.of(context)!.noNotesTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => const ViewNotePage())),
            child: Text(AppLocalizations.of(context)!.createNoteButton),
          ),
        ],
      ),
    );
  }
}
