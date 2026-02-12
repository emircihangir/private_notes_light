import 'package:private_notes_light/features/backup/domain/backup_data.dart';

sealed class ImportException extends Error {
  String? message;
}

class FilePickAborted extends ImportException {}

class CouldNotParseJson extends ImportException {
  @override
  String? get message =>
      'Could not parse the selected file. Make sure the file follows JSON syntax.';
}

class FileIsCorrupt extends ImportException {
  @override
  String? get message => 'File is corrupt. Failed to retrieve data.';
}

class RequiresPasswordInput extends ImportException {
  final BackupData backupData;
  RequiresPasswordInput(this.backupData);
}
