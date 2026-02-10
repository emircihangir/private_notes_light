import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/application/auth_service.dart';
import 'package:private_notes_light/application/filtered_notes_list.dart';
import 'package:private_notes_light/application/note_controller.dart';
import 'package:private_notes_light/application/search_query.dart';
import 'package:private_notes_light/presentation/login_screen.dart';
import 'package:private_notes_light/presentation/settings_page.dart';
import 'package:private_notes_light/presentation/view_note_page.dart';
import 'package:private_notes_light/presentation/generic_error_widget.dart';
import 'package:private_notes_light/presentation/snackbars.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == .paused || state == .inactive) {
      ref.read(authServiceProvider.notifier).logout();
    }

    if (state == .resumed) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
      showLoginAgainSnackbar(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = ref.watch(filteredNotesListProvider);
    final fullNotesList = ref.watch(noteControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            ref.read(authServiceProvider.notifier).logout();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          },
          icon: Icon(Icons.logout_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage())),
            icon: Icon(Icons.settings_outlined),
          ),
          IconButton(
            onPressed: () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewNotePage())),
            icon: Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: fullNotesList.when(
          error: (error, stackTrace) => Center(child: GenericErrorWidget()),
          loading: () => Center(child: CircularProgressIndicator()),
          data: (_) => Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                SearchBar(
                  leading: Icon(Icons.search),
                  hintText: 'Search',
                  onChanged: (value) => ref.read(searchQueryProvider.notifier).set(value),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final ({String noteID, String noteTitle}) note = filteredNotes[index];

                      return Dismissible(
                        onDismissed: (direction) async {
                          try {
                            await ref.read(noteControllerProvider.notifier).removeNote(note.noteID);
                          } catch (e) {
                            if (context.mounted) showErrorSnackbar(context);
                          }
                        },
                        confirmDismiss: (direction) async {
                          final bool? shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Note?'),
                              content: const Text('This action cannot be undone.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                                  ),
                                ),
                              ],
                            ),
                          );

                          return shouldDelete ?? false;
                        },
                        key: ValueKey(note.noteID),
                        direction: .endToStart,
                        background: Container(
                          color: Theme.of(context).colorScheme.errorContainer,
                          padding: EdgeInsets.only(right: 8),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.clear_rounded,
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                        child: ListTile(
                          title: Text(note.noteTitle),
                          onTap: () async {
                            final result = await ref
                                .read(noteControllerProvider.notifier)
                                .openNote(note.noteID);
                            if (context.mounted) {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ViewNotePage(note: result)),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class EmptyNotesWidget extends StatelessWidget {
  const EmptyNotesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        spacing: 16,
        children: [
          Text('No notes.', style: Theme.of(context).textTheme.headlineMedium),
          TextButton(
            onPressed: () =>
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewNotePage())),
            child: Text('Create One'),
          ),
        ],
      ),
    );
  }
}
