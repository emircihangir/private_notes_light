import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'note_repository.g.dart';

abstract class NoteRepository {
  Future<void> addNote(NoteDto dto);
  Future<void> importNotes(List<NoteDto> noteDTOs);
  Future<void> removeNote(String noteID);
  Future<List<NoteDto>> getNotes();
  Future<NoteDto> getNote(String noteID);
  Future<Database> get database;
}

class NoteRepositoryImpl implements NoteRepository {
  Database? _database;

  @override
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

  @override
  Future<void> addNote(NoteDto dto) async {
    final db = await database;
    await db.insert('notes', dto.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> importNotes(List<NoteDto> noteDTOs) async {
    final db = await database;
    Batch batch = db.batch();
    for (NoteDto noteDTO in noteDTOs) {
      batch.insert('notes', noteDTO.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<NoteDto>> getNotes() async {
    final db = await database;
    final notes = await db.query('notes', orderBy: 'dateCreated DESC');
    return notes.map((e) => NoteDto.fromJson(e)).toList();
  }

  @override
  Future<void> removeNote(String noteID) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [noteID]);
  }

  @override
  Future<NoteDto> getNote(String noteID) async {
    final db = await database;
    final result = await db.query('notes', where: 'id = ?', whereArgs: [noteID]);
    final NoteDto resultDto = result.map((e) => NoteDto.fromJson(e)).toList().first;
    return resultDto;
  }
}

@riverpod
NoteRepositoryImpl noteRepository(Ref ref) => NoteRepositoryImpl();
