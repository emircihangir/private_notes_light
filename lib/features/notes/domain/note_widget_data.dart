import 'package:freezed_annotation/freezed_annotation.dart';

part 'note_widget_data.freezed.dart';

@freezed
abstract class NoteWidgetData with _$NoteWidgetData {
  const factory NoteWidgetData({required String noteId, required String noteTitle}) =
      _NoteWidgetData;
}
