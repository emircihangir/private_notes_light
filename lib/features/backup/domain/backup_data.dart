import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:private_notes_light/features/authentication/domain/credentials_data.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/settings/domain/settings_data.dart';
import 'package:flutter/foundation.dart';

part 'backup_data.freezed.dart';
part 'backup_data.g.dart';

@freezed
abstract class BackupData with _$BackupData {
  factory BackupData({
    required CredentialsData credentialsData,
    required SettingsData settingsData,
    required List<NoteDto> notesData,
  }) = _BackupData;

  BackupData._();

  factory BackupData.fromJson(Map<String, Object?> json) => _$BackupDataFromJson(json);

  static const propertyNames = (
    credentialsData: 'credentialsData',
    settingsData: 'settingsData',
    notesData: 'notesData',
  );
}
