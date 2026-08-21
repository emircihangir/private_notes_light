import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/note_dto.dart';
import 'package:private_notes_light/features/settings/domain/settings_data.dart';
import 'package:private_notes_light/features/settings/domain/sorting_option.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:encrypt/encrypt.dart' as enc;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late NoteRepository repository;
  late Directory databaseDirectory;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    databaseDirectory = await Directory.systemTemp.createTemp('private_notes_light_note_repository_test_');
    await databaseFactory.setDatabasesPath(databaseDirectory.path);
  });

  tearDownAll(() async {
    if (await databaseDirectory.exists()) {
      await databaseDirectory.delete(recursive: true);
    }
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues(_settingsValues());
    final container = ProviderContainer();
    addTearDown(container.dispose);
    repository = container.read(noteRepositoryProvider);
    await repository.deleteAllNotes();
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

    test('getNote returns a note by id', () async {
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

      // Act
      final note = await repository.getNote(dummyDto.id);

      // Verify
      expect(note, dummyDto);
    });

    test('getNote returns null when no note exists for id', () async {
      // Act
      final note = await repository.getNote('missing-id');

      // Verify
      expect(note, isNull);
    });

    test('removeNote works', () async {
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

      // Act
      await repository.removeNote(dummyDto.id);

      // Verify
      expect(await repository.getNote(dummyDto.id), isNull);
      expect(await repository.getNotes(), isEmpty);
    });

    test('batchDelete deletes only matching notes', () async {
      // Setup
      final dummyValues = (iv: enc.IV.fromLength(16), date: DateTime.now());
      final dummyDto = NoteDto(
        id: 'id',
        title: 'title',
        content: 'content',
        iv: dummyValues.iv.base64,
        dateCreated: dummyValues.date.toIso8601String(),
      );
      await repository.addNote(dummyDto.copyWith(id: 'id1'));
      await repository.addNote(dummyDto.copyWith(id: 'id2'));
      await repository.addNote(dummyDto.copyWith(id: 'id3'));

      // Act
      await repository.batchDelete(['id1', 'id3']);

      // Verify
      expect(await repository.getNote('id1'), isNull);
      expect(await repository.getNote('id3'), isNull);
      expect(await repository.getNote('id2'), dummyDto.copyWith(id: 'id2'));
      expect(await repository.getNotes(), [dummyDto.copyWith(id: 'id2')]);
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

      final List<NoteDto> dtoList = [dummyDto, dummyDto.copyWith(id: 'id2'), dummyDto.copyWith(id: 'id3')];

      // Act
      await repository.importNotes(dtoList);

      // Verify
      final notes = await repository.getNotes();

      expect(notes.length, 3);
      expect(await repository.getNote('to_be_deleted_1'), isNull);
      expect(await repository.getNote('to_be_deleted_2'), isNull);
    });

    test('getNotes uses the configured sorting option', () async {
      // Setup
      SharedPreferences.setMockInitialValues(_settingsValues(sortingOption: SortingOption.aToZ));
      final dummyValues = (iv: enc.IV.fromLength(16), date: DateTime.now());
      await repository.addNote(
        NoteDto(
          id: 'id1',
          title: 'Charlie',
          content: 'content',
          iv: dummyValues.iv.base64,
          dateCreated: dummyValues.date.toIso8601String(),
        ),
      );
      await repository.addNote(
        NoteDto(
          id: 'id2',
          title: 'alpha',
          content: 'content',
          iv: dummyValues.iv.base64,
          dateCreated: dummyValues.date.add(const Duration(days: 1)).toIso8601String(),
        ),
      );
      await repository.addNote(
        NoteDto(
          id: 'id3',
          title: 'Bravo',
          content: 'content',
          iv: dummyValues.iv.base64,
          dateCreated: dummyValues.date.add(const Duration(days: 2)).toIso8601String(),
        ),
      );

      // Act
      final notes = await repository.getNotes();

      // Verify
      expect(notes.map((e) => e.title), ['alpha', 'Bravo', 'Charlie']);
    });
  });
}

Map<String, Object> _settingsValues({SortingOption sortingOption = SortingOption.newestFirst}) {
  return {
    SettingsData.propertyNames.exportSuggestions: true,
    SettingsData.propertyNames.exportWarnings: true,
    SettingsData.propertyNames.theme: ThemeMode.system.name,
    SettingsData.propertyNames.sortingOption: sortingOption.name,
  };
}
