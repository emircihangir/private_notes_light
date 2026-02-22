import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/application/search_query.dart';
import 'package:private_notes_light/features/notes/domain/note_widget_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'filtered_notes_list.g.dart';

@riverpod
List<NoteWidgetData> filteredNotesList(Ref ref) {
  final searchQuery = ref.watch(searchQueryProvider);
  final noteController = ref.watch(noteControllerProvider);
  final notesList = noteController.valueOrNull?.data ?? [];
  if (searchQuery.isEmpty) return notesList;

  return notesList
      .where((e) => e.noteTitle.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();
}
