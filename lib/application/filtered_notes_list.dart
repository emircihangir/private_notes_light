import 'package:private_notes_light/application/note_controller.dart';
import 'package:private_notes_light/application/search_query.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'filtered_notes_list.g.dart';

@riverpod
List<({String noteID, String noteTitle})> filteredNotesList(Ref ref) {
  final searchQuery = ref.watch(searchQueryProvider);
  final notesListAsync = ref.watch(noteControllerProvider);

  final notesList = notesListAsync.valueOrNull ?? [];

  if (searchQuery.isEmpty) return notesList;

  return notesList
      .where((e) => e.noteTitle.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();
}
