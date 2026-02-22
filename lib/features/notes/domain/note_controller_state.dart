import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:private_notes_light/features/notes/domain/note_widget_data.dart';

part 'note_controller_state.freezed.dart';

enum NoteErrorKind { failedToDeleteNote }

@freezed
abstract class NoteControllerState with _$NoteControllerState {
  const factory NoteControllerState({
    @Default([]) List<NoteWidgetData> data,
    NoteErrorKind? errorKind,
    @Default(false) bool showError,
    @Default(false) bool suggestExport,
    @Default(false) bool showExportSuccessful,
  }) = _NoteControllerState;
}
