import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/settings/data/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

part 'backup_repository.g.dart';

abstract class BackupRepository {
  Future<bool> export();
  Future<void> import();
}

class BackupRepositoryImpl implements BackupRepository {
  final Database db;
  final SettingsRecord settingsRecord;
  final DateFormat dateFormat = DateFormat('yyyy_MM_dd_HH_mm_ss');
  BackupRepositoryImpl(this.db, this.settingsRecord);

  @override
  Future<bool> export() async {
    Map<String, dynamic> exportData = {
      "settings": {
        "exportSuggestions": settingsRecord.exportSuggestions.toString(),
        "exportWarnings": settingsRecord.exportWarnings.toString(),
        "theme": settingsRecord.brightness ?? "system",
      },
    };

    final List<Map<String, Object?>> allNotes = await db.query('notes');
    exportData['notes'] = allNotes;

    final exportDataJsonString = jsonEncode(exportData);

    final tempDir = await getTemporaryDirectory();
    final fileName = 'private_notes_export_${dateFormat.format(DateTime.now())}.json';
    final filePath = p.join(tempDir.path, fileName);
    final file = File(filePath);

    await file.writeAsString(exportDataJsonString);

    final result = await FilePicker.platform.saveFile(
      fileName: fileName,
      dialogTitle: 'Save Export File',
      bytes: await file.readAsBytes(),
    );

    if (result == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<void> import() async {}
}

@riverpod
FutureOr<BackupRepository> backupRepository(Ref ref) async {
  final noteRepo = ref.watch(noteRepositoryProvider);
  final db = await noteRepo.database;

  final settingsRepo = await ref.watch(settingsRepositoryProvider.future);
  final settingsRecord = settingsRepo.getSettings();

  return BackupRepositoryImpl(db, settingsRecord);
}
