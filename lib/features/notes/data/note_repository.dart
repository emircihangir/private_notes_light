import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'note_repository.g.dart';

class NoteRepository {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('private_notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id TEXT PRIMARY KEY,
        title TEXT,
        content TEXT,
        iv TEXT,
        dateCreated TEXT
      )
    ''');
  }

  Future<void> addNote(NoteDto dto) async {
    final db = await database;
    await db.insert('notes', dto.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> importNotes(List<NoteDto> noteDTOs) async {
    final db = await database;

    // * Delete all rows from the notes table.
    await db.delete('notes');

    Batch batch = db.batch();
    for (NoteDto noteDTO in noteDTOs) {
      batch.insert('notes', noteDTO.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<NoteDto>> getNotes() async {
    final db = await database;
    final notes = await db.query('notes', orderBy: 'dateCreated DESC');
    return notes.map((e) => NoteDto.fromJson(e)).toList();
  }

  Future<void> removeNote(String noteID) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [noteID]);
  }

  Future<NoteDto> getNote(String noteID) async {
    final db = await database;
    final result = await db.query('notes', where: 'id = ?', whereArgs: [noteID]);
    final NoteDto resultDto = result.map((e) => NoteDto.fromJson(e)).toList().first;
    return resultDto;
  }
}

@riverpod
NoteRepository noteRepository(Ref ref) => NoteRepository();
