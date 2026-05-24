import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/notes/data/title_warning_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TitleWarningRepository tests ->', () {
    test('getPref returns true by default', () async {
      // Setup
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repository = TitleWarningRepository(prefs);

      // Act & Verify
      expect(repository.getPref(), isTrue);
    });

    test('setPref persists value', () async {
      // Setup
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repository = TitleWarningRepository(prefs);

      // Act
      await repository.setPref(false);

      // Verify
      expect(repository.getPref(), isFalse);
    });

    test('provider returns repository', () async {
      // Setup
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act & Verify
      expect(await container.read(titleWarningRepositoryProvider.future), isA<TitleWarningRepository>());
    });
  });
}
