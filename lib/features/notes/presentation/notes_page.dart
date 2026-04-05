import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/core/fade_page_route_builder.dart';
import 'package:private_notes_light/features/notes/application/filtered_notes_list.dart';
import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/application/search_query.dart';
import 'package:private_notes_light/features/authentication/presentation/login_screen.dart';
import 'package:private_notes_light/features/notes/application/session_expired.dart';
import 'package:private_notes_light/features/notes/application/trashed_notes.dart';
import 'package:private_notes_light/features/notes/domain/note_controller_state.dart';
import 'package:private_notes_light/features/notes/domain/note_widget_data.dart';
import 'package:private_notes_light/features/notes/presentation/create_note_page.dart';
import 'package:private_notes_light/features/notes/presentation/empty_notes_widget.dart';
import 'package:private_notes_light/features/notes/presentation/notes_list.dart';
import 'package:private_notes_light/features/notes/presentation/view_note_page.dart';
import 'package:private_notes_light/features/notes/presentation/trashed_notes_sheet.dart';
import 'package:private_notes_light/features/settings/application/app_version.dart';
import 'package:private_notes_light/features/settings/application/settings_controller.dart';
import 'package:private_notes_light/features/settings/presentation/settings_page.dart';
import 'package:private_notes_light/core/generic_error_widget.dart';
import 'package:private_notes_light/core/snackbars.dart';
import 'package:private_notes_light/l10n/app_localizations.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  // Handlers
  void handleDismiss(DismissDirection direction, NoteWidgetData noteWidgetData) {
    log('Note list tile dismissed.', name: 'INFO');
    ref.read(noteControllerProvider.notifier).moveNoteToTrash(noteWidgetData);
  }

  void handlePlusTap() {
    ScaffoldMessenger.of(context).clearSnackBars();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CreateNotePage()));
  }

  void handleSettingsTap() {
    ScaffoldMessenger.of(context).clearSnackBars();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsPage()));
  }

  void handleLogout() {
    ref.read(noteControllerProvider.notifier).logout();
    ScaffoldMessenger.of(context).clearSnackBars();
    Navigator.of(context).pushAndRemoveUntil(fadePageRouteBuilder(const LoginScreen()), (route) => false);
  }

  Future<void> handleTrashTap() async {
    await showModalBottomSheet(showDragHandle: true, context: context, builder: (context) => const TrashedNotesSheet());
  }

  Future<void> handleNoteWidgetTap(NoteWidgetData noteWidgetData) async {
    final openedNote = await ref.read(noteControllerProvider.notifier).openNote(noteWidgetData.noteId);
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewNotePage(note: openedNote)));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.read(settingsControllerProvider); // pre-warm
    ref.read(appVersionProvider); // pre-warm

    ref.watch(sessionLifecycleProvider);
    ref.listen<bool>(sessionExpiredProvider, (previous, next) {
      if (next == true) {
        ScaffoldMessenger.of(context).clearSnackBars();
        Navigator.of(context).pushAndRemoveUntil(fadePageRouteBuilder(const LoginScreen()), (route) => false);
        showInfoSnackbar(context, content: AppLocalizations.of(context)!.sessionExpiredMessage);
        ref.read(sessionExpiredProvider.notifier).setExpired(false);
      }
    });

    final filteredNotes = ref.watch(filteredNotesListProvider);
    final noteController = ref.watch(noteControllerProvider);

    ref.listen(noteControllerProvider, (previous, next) {
      final nextValue = next.asData?.value;
      final noteControllerNotifier = ref.read(noteControllerProvider.notifier);

      if (nextValue?.suggestExport == true) {
        showExportSuggestionSnackbar(context, () async => await noteControllerNotifier.triggerExport());
        noteControllerNotifier.consumeExportSuggestion();
      }
      if (nextValue?.showError == true) {
        final errorKind = nextValue!.errorKind!;

        switch (errorKind) {
          case NoteErrorKind.failedToDeleteNote:
            showErrorSnackbar(context, content: AppLocalizations.of(context)!.failedToDeleteNote);
            break;
          case NoteErrorKind.failedToExport:
            showErrorSnackbar(context, content: AppLocalizations.of(context)!.failedToExport);
            break;
        }

        noteControllerNotifier.consumeError();
      }
      if (nextValue?.showExportSuccessful == true) {
        showSuccessSnackbar(context, content: AppLocalizations.of(context)!.exportSuccess);
        noteControllerNotifier.consumeExportSuccess();
      }
      if (nextValue?.warnExport == true) {
        showExportWarningSnackbar(context, () async => await noteControllerNotifier.triggerExport());
        noteControllerNotifier.consumeExportWarning();
      }
      if (nextValue?.showInfo == true) {
        if (nextValue?.infoKind == InfoKind.noteDeleted) {
          showNoteDeletedSnackbar(context, noteControllerNotifier.undoDelete);
          noteControllerNotifier.consumeInfoSnackbar();
        }
      }
    });

    final trashedNotes = ref.watch(trashedNotesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notesTitle),
        centerTitle: true,
        leading: IconButton(onPressed: handleLogout, icon: const Icon(Icons.logout_rounded)),
        actions: [
          IconButton(onPressed: handleSettingsTap, icon: const Icon(Icons.settings_outlined)),
          trashedNotes.isNotEmpty
              ? IconButton(onPressed: () async => await handleTrashTap(), icon: const Icon(Icons.delete_outline_rounded))
              : const SizedBox(),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: handlePlusTap, child: const Icon(Icons.add_rounded)),
      body: SafeArea(
        child: noteController.when(
          error: (error, stackTrace) {
            log('', error: error, stackTrace: stackTrace, name: 'ERROR');
            return const Center(child: GenericErrorWidget());
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (noteControllerState) {
            final data = noteControllerState.data;

            return Padding(
              padding: const EdgeInsets.all(12),
              child: data.isNotEmpty
                  ? Column(
                      children: [
                        SearchBar(
                          leading: const Icon(Icons.search),
                          hintText: AppLocalizations.of(context)!.searchHint,
                          onChanged: (value) => ref.read(searchQueryProvider.notifier).set(value),
                        ),
                        filteredNotes.isNotEmpty
                            ? NotesList(
                                filteredNotes: filteredNotes,
                                onDismissed: (direction, noteWidgetData) => handleDismiss(direction, noteWidgetData),
                                onTap: handleNoteWidgetTap,
                              )
                            : const NoNotesFoundWidget(),
                      ],
                    )
                  : const EmptyNotesWidget(),
            );
          },
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
