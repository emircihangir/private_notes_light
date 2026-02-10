import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Note extends Equatable {
  final String id;
  final String title;
  final String content;
  final DateTime dateCreated;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.dateCreated,
  });

  Note copyWith({String? id, String? title, String? content, DateTime? dateCreated}) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  List<Object?> get props => [id, title, content, dateCreated];
}
