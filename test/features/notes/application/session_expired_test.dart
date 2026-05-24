import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/backup/application/file_picker_running.dart';
import 'package:private_notes_light/features/notes/application/note_controller.dart';
import 'package:private_notes_light/features/notes/application/session_expired.dart';
import 'package:private_notes_light/features/notes/domain/note_controller_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SessionExpired tests ->', () {
    test('setExpired updates state', () {
      // Setup
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      container.read(sessionExpiredProvider.notifier).setExpired(true);

      // Verify
      expect(container.read(sessionExpiredProvider), isTrue);
    });
  });

  group('SessionLifecycleObserver tests ->', () {
    test('inactive logs out and resumed marks session expired', () {
      // Setup
      final fakeNoteController = FakeNoteController();
      final container = ProviderContainer(overrides: [noteControllerProvider.overrideWith(() => fakeNoteController)]);
      addTearDown(container.dispose);
      final observer = container.read(sessionLifecycleProvider);

      // Act
      observer.didChangeAppLifecycleState(AppLifecycleState.inactive);
      observer.didChangeAppLifecycleState(AppLifecycleState.resumed);

      // Verify
      expect(fakeNoteController.logoutCalled, isTrue);
      expect(container.read(sessionExpiredProvider), isTrue);
      expect(observer.logoutOnResume, isFalse);
    });

    test('inactive does not log out while file picker is running', () {
      // Setup
      final fakeNoteController = FakeNoteController();
      final container = ProviderContainer(overrides: [noteControllerProvider.overrideWith(() => fakeNoteController)]);
      addTearDown(container.dispose);
      container.read(filePickerRunningProvider.notifier).set(true);
      final observer = container.read(sessionLifecycleProvider);

      // Act
      observer.didChangeAppLifecycleState(AppLifecycleState.inactive);
      observer.didChangeAppLifecycleState(AppLifecycleState.resumed);

      // Verify
      expect(fakeNoteController.logoutCalled, isFalse);
      expect(container.read(sessionExpiredProvider), isFalse);
      expect(observer.logoutOnResume, isFalse);
    });
  });
}

class FakeNoteController extends NoteController {
  bool logoutCalled = false;

  @override
  Future<NoteControllerState> build() async => const NoteControllerState();

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }
}
