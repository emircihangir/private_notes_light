import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/authentication/data/auth_repository.dart';
import 'package:private_notes_light/features/backup/application/file_picker_running.dart';
import 'package:private_notes_light/features/backup/data/backup_repository.dart';
import 'package:private_notes_light/features/backup/domain/backup_data.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/settings/data/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'export_service.g.dart';

@riverpod
Future<bool?> exportService(Ref ref) async {
  final backupRepo = await ref.watch(backupRepositoryProvider.future);
  final authRepo = ref.watch(authRepositoryProvider);
  final noteRepo = ref.watch(noteRepositoryProvider);
  final settingsRepo = await ref.watch(settingsRepositoryProvider.future);

  final exportData = BackupData(
    credentialsData: await authRepo.readCredentials(),
    settingsData: settingsRepo.getSettings(),
    notesData: await noteRepo.getNotes(),
  );

  // * Convert BackupData.notesData from List<NoteDto> to List<Map<String, dynamic>>.
  final exportDataMap = exportData.toJson();
  final List<NoteDto> notesData = exportDataMap[BackupData.propertyNames.notesData];
  final List<Map<String, dynamic>> expandedNotesData = [];
  for (int i = 0; i < notesData.length; i++) {
    expandedNotesData.add(notesData[i].toJson());
  }
  exportDataMap[BackupData.propertyNames.notesData] = expandedNotesData;

  ref.read(filePickerRunningProvider.notifier).set(true);
  final exportResult = await backupRepo.export(exportDataMap);
  ref.read(filePickerRunningProvider.notifier).set(false);

  return exportResult;
}
