import 'package:flutter/material.dart';
import 'package:private_notes_light/features/authentication/domain/credentials_data.dart';
import 'package:private_notes_light/features/backup/domain/backup_data.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/settings/domain/settings_data.dart';
import 'package:encrypt/encrypt.dart' as enc;

BackupData dummyBackupData({enc.IV? credentialsIv, List<NoteDto>? notes}) => BackupData(
  credentialsData: CredentialsData(
    salt: 'salt',
    iv: credentialsIv?.base64 ?? 'iviv',
    encryptedMasterKey: 'encryptedMasterKey',
  ),
  settingsData: SettingsData(
    exportSuggestions: true,
    exportWarnings: true,
    theme: ThemeMode.system,
  ),
  notesData:
      notes ??
      [
        NoteDto(
          id: 'id',
          title: 'title',
          content: 'content',
          iv: 'iviv',
          dateCreated: 'dateCreated',
        ),
      ],
);
