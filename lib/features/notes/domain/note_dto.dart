import 'package:meta/meta.dart';
import 'package:private_notes_light/features/notes/domain/note.dart';

@immutable
class NoteDto {
  final String id;
  final String title;
  final String content;
  final String iv;
  final String dateCreated;

  const NoteDto({
    required this.id,
    required this.title,
    required this.content,
    required this.iv,
    required this.dateCreated,
  });

  factory NoteDto.fromDomain(Note note, String encryptedContent, String iv) {
    return NoteDto(
      id: note.id,
      title: note.title,
      content: encryptedContent,
      iv: iv,
      dateCreated: note.dateCreated.toIso8601String(),
    );
  }

  // Add this factory
  factory NoteDto.fromMap(Map<String, dynamic> map) {
    return NoteDto(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      iv: map['iv'] as String,
      dateCreated: map['date_created'] as String,
    );
  }

  // Convert to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content, // The encrypted blob
      'iv': iv,
      'date_created': dateCreated,
    };
  }
}
