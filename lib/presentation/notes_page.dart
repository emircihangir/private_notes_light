import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/application/note_controller.dart';
import 'package:private_notes_light/presentation/create_note_page.dart';
import 'package:private_notes_light/presentation/generic_error_widget.dart';

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

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final ({String noteID, String noteTitle}) note = data[index];
                return ListTile(title: Text(note.noteTitle));
              },
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
