import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:private_notes_light/features/backup/application/file_picker_service.dart';
import 'package:private_notes_light/features/backup/domain/backup_data.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/settings/data/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

part 'backup_repository.g.dart';

class BackupRepository {
  final DateFormat dateFormat = DateFormat('yyyy_MM_dd_HH_mm_ss');
  final SettingsRepository settingsRepo;
  final NoteRepository noteRepo;
  final FilePickerService filePickerService;
  final _lastExportDateKey = 'lastExportDate';

  BackupRepository({
    required this.settingsRepo,
    required this.noteRepo,
    required this.filePickerService,
  });

  Future<bool?> export(Map<String, dynamic> exportDataMap) async {
    final exportJsonString = jsonEncode(exportDataMap);

    final tempDir = await getTemporaryDirectory();
    final fileName = 'private_notes_export_${dateFormat.format(DateTime.now())}.json';
    final filePath = p.join(tempDir.path, fileName);
    final file = File(filePath);

    await file.writeAsString(exportJsonString);

    final pickerResult = await filePickerService.saveFile(
      fileName: fileName,
      dialogTitle: 'Save Export File',
      bytes: await file.readAsBytes(),
    );

    final operationResult = pickerResult != null;
    if (operationResult == true) {
      _setLastExportDate();
    }

    return operationResult;
  }

  Future<void> _setLastExportDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastExportDateKey, DateTime.now().toIso8601String());
  }

  Future<DateTime?> getLastExportDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_lastExportDateKey);
    if (dateString == null) {
      return null;
    } else {
      return DateTime.tryParse(dateString);
    }
  }

  Future<void> import(BackupData importData, bool alsoImportSettings) async {
    await noteRepo.importNotes(importData.notesData);
    if (alsoImportSettings) await settingsRepo.importSettings(importData.settingsData);
  }
}

@riverpod
Future<BackupRepository> backupRepository(Ref ref) async {
  final settingsRepo = await ref.watch(settingsRepositoryProvider.future);
  final noteRepo = ref.watch(noteRepositoryProvider);
  final filePickerService = ref.read(filePickerServiceProvider);

  return BackupRepository(
    settingsRepo: settingsRepo,
    noteRepo: noteRepo,
    filePickerService: filePickerService,
  );
}
