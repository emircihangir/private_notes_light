import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:private_notes_light/features/backup/application/export_service.dart';
import 'package:private_notes_light/features/encryption/application/master_key.dart';
import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/data/note_repository.dart';
import 'package:private_notes_light/features/notes/domain/note_controller_state.dart';
import 'package:encrypt/encrypt.dart' as enc;

@GenerateNiceMocks([MockSpec<NoteRepository>()])
import 'note_controller_test.mocks.dart';

void main() {
  late MockNoteRepository mockNoteRepo;

  setUp(() {
    mockNoteRepo = MockNoteRepository();
  });

  group('triggerExport works', () {
    test('shows success if export result is true', () async {
      // Setup
      final container = ProviderContainer(
        overrides: [
          noteRepositoryProvider.overrideWith((ref) => mockNoteRepo),
          exportServiceProvider.overrideWith((ref) async => true),
        ],
      );
      addTearDown(container.dispose);

      final dummyKey = enc.Key.fromLength(32);
      container.read(masterKeyProvider.notifier).set(dummyKey);

      // Act
      await container.read(noteControllerProvider.notifier).triggerExport();

      // Verify
      expect(container.read(noteControllerProvider).value!.showExportSuccessful, isTrue);
    });

    test('shows error if export result is false', () async {
      // Setup
      final container = ProviderContainer(
        overrides: [
          noteRepositoryProvider.overrideWith((ref) => mockNoteRepo),
          exportServiceProvider.overrideWith((ref) async => false),
        ],
      );
      addTearDown(container.dispose);

      final dummyKey = enc.Key.fromLength(32);
      container.read(masterKeyProvider.notifier).set(dummyKey);

      // Act
      await container.read(noteControllerProvider.notifier).triggerExport();

      // Verify
      expect(container.read(noteControllerProvider).value!.showError, isTrue);
      expect(container.read(noteControllerProvider).value!.errorKind, NoteErrorKind.failedToExport);
    });
  });
}
