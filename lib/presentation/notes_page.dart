import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/application/note_controller.dart';
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
      body: SafeArea(
        child: notes.when(
          data: (data) {
            if (data.isEmpty) return EmptyNotesWidget();

            return ListView.builder(
              itemBuilder: (context, index) {
                final note = data[index];
                return ListTile(title: Text(note.title));
              },
            );
          },
          error: (error, stackTrace) => GenericErrorWidget(),
          loading: () => CircularProgressIndicator(),
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
          TextButton(onPressed: () {}, child: Text('Create One')),
        ],
      ),
    );
  }
}
