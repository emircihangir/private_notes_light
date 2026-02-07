import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/application/note_controller.dart';
import 'package:private_notes_light/presentation/view_note_page.dart';
import 'package:private_notes_light/presentation/generic_error_widget.dart';
import 'package:private_notes_light/presentation/snackbars.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(noteControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.logout_rounded)),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => CreateNotePage())),
            icon: Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: notes.when(
          data: (data) {
            if (data.isEmpty) return EmptyNotesWidget();

            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  SearchBar(leading: Icon(Icons.search), hintText: 'Search'),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final ({String noteID, String noteTitle}) note = data[index];

                        return Dismissible(
                          onDismissed: (direction) async {
                            try {
                              await ref
                                  .read(noteControllerProvider.notifier)
                                  .removeNote(note.noteID);
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
                                  MaterialPageRoute(
                                    builder: (context) => CreateNotePage(note: result),
                                  ),
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
            );
          },
          error: (error, stackTrace) => Center(child: GenericErrorWidget()),
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
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
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => CreateNotePage())),
            child: Text('Create One'),
          ),
        ],
      ),
    );
  }
}
