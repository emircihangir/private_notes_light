import 'package:flutter/material.dart';
import 'package:private_notes_light/features/authentication/domain/credentials_data.dart';
import 'package:private_notes_light/features/backup/domain/backup_data.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/settings/domain/settings_data.dart';

BackupData dummyBackupData() => BackupData(
  credentialsData: CredentialsData(
    salt: 'salt',
    iv: 'iviv',
    encryptedMasterKey: 'encryptedMasterKey',
  ),
  settingsData: SettingsData(
    exportSuggestions: true,
    exportWarnings: true,
    theme: ThemeMode.system,
  ),
  notesData: [
    NoteDto(id: 'id', title: 'title', content: 'content', iv: 'iv', dateCreated: 'dateCreated'),
  ],
);
