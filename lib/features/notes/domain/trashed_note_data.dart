import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:private_notes_light/features/notes/domain/note_widget_data.dart';

part 'trashed_note_data.freezed.dart';

@freezed
abstract class TrashedNoteData with _$TrashedNoteData {
  const factory TrashedNoteData(NoteWidgetData noteWidgetData, int index) = _TrashedNoteData;
}
