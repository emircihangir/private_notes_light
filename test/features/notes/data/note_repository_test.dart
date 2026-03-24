import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:encrypt/encrypt.dart' as enc;

void main() {
  late NoteRepository repository;

  setUp(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    repository = NoteRepository();
  });

  group('NoteRepository tests ->', () {
    test('addNote works', () async {
      // Setup
      final dummyValues = (iv: enc.IV.fromLength(16), date: DateTime.now());
      final dummyDto = NoteDto(
        id: 'id',
        title: 'title',
        content: 'content',
        iv: dummyValues.iv.base64,
        dateCreated: dummyValues.date.toIso8601String(),
      );

      // Act
      await repository.addNote(dummyDto);

      // Verify
      final notes = await repository.getNotes();
      expect(notes.length, 1);
      expect(notes.contains(dummyDto), isTrue);
    });

    test('deleteAllNotes works', () async {
      // Setup
      final dummyValues = (iv: enc.IV.fromLength(16), date: DateTime.now());
      final dummyDto = NoteDto(
        id: 'id',
        title: 'title',
        content: 'content',
        iv: dummyValues.iv.base64,
        dateCreated: dummyValues.date.toIso8601String(),
      );
      await repository.addNote(dummyDto);
      await repository.addNote(dummyDto.copyWith(id: 'id2'));

      // Act
      await repository.deleteAllNotes();

      // Verify
      final notes = await repository.getNotes();
      expect(notes.isEmpty, isTrue);
    });

    test('importNotes works', () async {
      // Setup
      final dummyValues = (iv: enc.IV.fromLength(16), date: DateTime.now());
      final dummyDto = NoteDto(
        id: 'id',
        title: 'title',
        content: 'content',
        iv: dummyValues.iv.base64,
        dateCreated: dummyValues.date.toIso8601String(),
      );

      await repository.addNote(dummyDto.copyWith(id: 'to_be_deleted_1'));
      await repository.addNote(dummyDto.copyWith(id: 'to_be_deleted_2'));

      final List<NoteDto> dtoList = [
        dummyDto,
        dummyDto.copyWith(id: 'id2'),
        dummyDto.copyWith(id: 'id3'),
      ];

      // Act
      await repository.importNotes(dtoList);

      // Verify
      final notes = await repository.getNotes();

      expect(notes.length, 3);
      expect(await repository.getNote('to_be_deleted_1'), isNull);
      expect(await repository.getNote('to_be_deleted_2'), isNull);
    });
  });
}
