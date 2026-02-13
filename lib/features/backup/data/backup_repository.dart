import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:private_notes_light/features/backup/domain/backup_data.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/settings/data/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as p;

part 'backup_repository.g.dart';

abstract class BackupRepository {
  Future<void> export(Map<String, dynamic> exportDataMap);
  Future<void> import(BackupData importData, bool alsoImportSettings);
}

class BackupRepositoryImpl implements BackupRepository {
  final DateFormat dateFormat = DateFormat('yyyy_MM_dd_HH_mm_ss');
  final SettingsRepository settingsRepo;
  final NoteRepository noteRepo;

  BackupRepositoryImpl({required this.settingsRepo, required this.noteRepo});

  @override
  Future<void> export(Map<String, dynamic> exportDataMap) async {
    final exportJsonString = jsonEncode(exportDataMap);

    final tempDir = await getTemporaryDirectory();
    final fileName = 'private_notes_export_${dateFormat.format(DateTime.now())}.json';
    final filePath = p.join(tempDir.path, fileName);
    final file = File(filePath);

    await file.writeAsString(exportJsonString);

    await FilePicker.platform.saveFile(
      fileName: fileName,
      dialogTitle: 'Save Export File',
      bytes: await file.readAsBytes(),
    );
  }

  @override
  Future<void> import(BackupData importData, bool alsoImportSettings) async {
    await noteRepo.importNotes(importData.notesData);
    if (alsoImportSettings) await settingsRepo.importSettings(importData.settingsData);
  }
}

@riverpod
Future<BackupRepository> backupRepository(Ref ref) async {
  final settingsRepo = await ref.watch(settingsRepositoryProvider.future);
  final noteRepo = ref.watch(noteRepositoryProvider);

  return BackupRepositoryImpl(settingsRepo: settingsRepo, noteRepo: noteRepo);
}
