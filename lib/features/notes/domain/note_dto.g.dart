// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoteDto _$NoteDtoFromJson(Map<String, dynamic> json) => _NoteDto(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] as String,
  iv: json['iv'] as String,
  dateCreated: json['dateCreated'] as String,
);

Map<String, dynamic> _$NoteDtoToJson(_NoteDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'iv': instance.iv,
  'dateCreated': instance.dateCreated,
};
