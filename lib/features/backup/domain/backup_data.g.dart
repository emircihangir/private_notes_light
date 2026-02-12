// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BackupData _$BackupDataFromJson(Map<String, dynamic> json) => _BackupData(
  credentialsData: CredentialsData.fromJson(
    json['credentialsData'] as Map<String, dynamic>,
  ),
  settingsData: SettingsData.fromJson(
    json['settingsData'] as Map<String, dynamic>,
  ),
  notesData: (json['notesData'] as List<dynamic>)
      .map((e) => NoteDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BackupDataToJson(_BackupData instance) =>
    <String, dynamic>{
      'credentialsData': instance.credentialsData,
      'settingsData': instance.settingsData,
      'notesData': instance.notesData,
    };
