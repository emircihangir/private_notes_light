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
  });
}
