import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/core/fade_page_route_builder.dart';
import 'package:private_notes_light/features/notes/application/filtered_notes_list.dart';
import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/application/search_query.dart';
import 'package:private_notes_light/features/authentication/presentation/login_screen.dart';
import 'package:private_notes_light/features/notes/application/session_expired.dart';
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

class _NotesPageState extends ConsumerState<NotesPage> {
  // Handlers
  Future<void> handleDismiss(DismissDirection direction, NoteWidgetData note) async {
    await ref.read(noteControllerProvider.notifier).removeNote(note.noteId);
  }

  void handlePlusTap() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewNotePage()));
  }

  void handleSettingsTap() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsPage()));
  }

  void handleLogout() {
    ref.read(noteControllerProvider.notifier).logout();
    Navigator.of(context).pushAndRemoveUntil(fadePageRouteBuilder(LoginScreen()), (route) => false);
  }

  Future<bool> handleConfirmDismiss(DismissDirection direction) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmDeleteDialog(),
    );
    return shouldDelete ?? false;
  }

  Future<void> handleNoteWidgetTap(NoteWidgetData noteWidgetData) async {
    final openedNote = await ref
        .read(noteControllerProvider.notifier)
        .openNote(noteWidgetData.noteId);
    if (mounted) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => ViewNotePage(note: openedNote)));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(sessionLifecycleProvider);
    ref.listen<bool>(sessionExpiredProvider, (previous, next) {
      if (next == true) {
        Navigator.of(
          context,
        ).pushAndRemoveUntil(fadePageRouteBuilder(LoginScreen()), (route) => false);
        showInfoSnackbar(context, content: AppLocalizations.of(context)!.sessionExpiredMessage);
        ref.read(sessionExpiredProvider.notifier).setExpired(false);
      }
    });

    final filteredNotes = ref.watch(filteredNotesListProvider);
    final noteController = ref.watch(noteControllerProvider);

    ref.listen(noteControllerProvider, (previous, next) {
      final nextValue = next.asData?.value;

      if (nextValue?.suggestExport == true) {
        showExportSuggestionSnackbar(
          context,
          () async => await ref.read(noteControllerProvider.notifier).triggerExport(),
        );
        ref.read(noteControllerProvider.notifier).consumeExportSuggestion();
      }
      if (nextValue?.showError == true) {
        showErrorSnackbar(context);
        ref.read(noteControllerProvider.notifier).consumeError();
      }
      if (nextValue?.showExportSuccessful == true) {
        showSuccessSnackbar(context, content: AppLocalizations.of(context)!.exportSuccess);
        ref.read(noteControllerProvider.notifier).consumeExportSuccess();
      }
      if (nextValue?.warnExport == true) {
        showExportWarningSnackbar(
          context,
          () async => await ref.read(noteControllerProvider.notifier).triggerExport(),
        );
        ref.read(noteControllerProvider.notifier).consumeExportWarning();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notesTitle),
        centerTitle: true,
        leading: IconButton(onPressed: handleLogout, icon: const Icon(Icons.logout_rounded)),
        actions: [
          IconButton(onPressed: handleSettingsTap, icon: const Icon(Icons.settings_outlined)),
          IconButton(onPressed: handlePlusTap, icon: const Icon(Icons.add_rounded)),
        ],
      ),
      body: SafeArea(
        child: noteController.when(
          error: (error, stackTrace) {
            log('', error: error, stackTrace: stackTrace, name: 'ERROR');
            return const Center(child: GenericErrorWidget());
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          data: (noteControllerState) {
            final data = noteControllerState?.data;
            final hasData = (data != null && data.isNotEmpty);

            return Padding(
              padding: const EdgeInsets.all(12),
              child: hasData
                  ? Column(
                      children: [
                        SearchBar(
                          leading: const Icon(Icons.search),
                          hintText: AppLocalizations.of(context)!.searchHint,
                          onChanged: (value) => ref.read(searchQueryProvider.notifier).set(value),
                        ),
                        filteredNotes.isNotEmpty
                            ? NotesList(
                                confirmDismiss: handleConfirmDismiss,
                                filteredNotes: filteredNotes,
                                onDismissed: (direction, noteWidgetData) =>
                                    handleDismiss(direction, noteWidgetData),
                                onTap: handleNoteWidgetTap,
                              )
                            : NoNotesFoundWidget(),
                      ],
                    )
                  : EmptyNotesWidget(),
            );
          },
        ),
      ),
    );
  }
}

class NotesList extends StatelessWidget {
  final List<NoteWidgetData> filteredNotes;
  final Future<void> Function(DismissDirection, NoteWidgetData) onDismissed;
  final ConfirmDismissCallback confirmDismiss;
  final Future<void> Function(NoteWidgetData) onTap;

  const NotesList({
    super.key,
    required this.filteredNotes,
    required this.onDismissed,
    required this.confirmDismiss,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) {
          final NoteWidgetData noteWidgetData = filteredNotes[index];

          return Dismissible(
            onDismissed: (direction) => onDismissed(direction, noteWidgetData),
            confirmDismiss: confirmDismiss,
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
              onTap: () => onTap(noteWidgetData),
            ),
          );
        },
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
