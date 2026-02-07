import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:private_notes_light/domain/note_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'note_repository.g.dart';

abstract class NoteRepository {
  Future<void> addNote(NoteDto dto);
  Future<void> removeNote(String noteID);
  Future<List<NoteDto>> getNotes();
}

class NoteRepositoryImpl implements NoteRepository {
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
        date_created TEXT
      )
    ''');
  }

  @override
  Future<void> addNote(NoteDto dto) async {
    final db = await database;
    await db.insert('notes', dto.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<NoteDto>> getNotes() async {
    final db = await database;
    final notes = await db.query('notes', orderBy: 'date_created DESC');
    return notes.map((e) => NoteDto.fromMap(e)).toList();
  }

  @override
  Future<void> removeNote(String noteID) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [noteID]);
  }
}

@riverpod
NoteRepository noteRepository(Ref ref) => NoteRepositoryImpl();
