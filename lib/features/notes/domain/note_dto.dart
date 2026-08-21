import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:private_notes_light/features/notes/domain/note.dart';

part 'note_dto.freezed.dart';
part 'note_dto.g.dart';

@freezed
abstract class NoteDto with _$NoteDto {
  factory NoteDto({
    required String id,
    required String title,
    required String content,
    required String iv,
    required String dateCreated,
  }) = _NoteDto;

  NoteDto._();

  factory NoteDto.fromDomain(Note note, String encryptedContent, String iv) {
    return NoteDto(
      id: note.id,
      title: note.title,
      content: encryptedContent,
      iv: iv,
      dateCreated: note.dateCreated.toIso8601String(),
    );
  }

  factory NoteDto.fromJson(Map<String, Object?> json) => _$NoteDtoFromJson(json);
}
