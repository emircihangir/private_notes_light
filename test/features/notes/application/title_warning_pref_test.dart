import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/notes/application/title_warning_pref.dart';
import 'package:private_notes_light/features/notes/data/title_warning_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late TitleWarningRepository repository;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repository = TitleWarningRepository(prefs);
    container = ProviderContainer(overrides: [titleWarningRepositoryProvider.overrideWith((ref) async => repository)]);
    addTearDown(container.dispose);
  });

  group('TitleWarningPref tests ->', () {
    test('build returns stored preference', () async {
      // Setup
      await repository.setPref(false);

      // Act
      final value = await container.read(titleWarningPrefProvider.future);

      // Verify
      expect(value, isFalse);
    });

    test('dismiss hides warning without persisting preference', () async {
      // Setup
      await container.read(titleWarningPrefProvider.future);

      // Act
      container.read(titleWarningPrefProvider.notifier).dismiss();

      // Verify
      expect(container.read(titleWarningPrefProvider).value, isFalse);
      expect(repository.getPref(), isTrue);
    });

    test('dontShowAgain hides warning and persists preference', () async {
      // Setup
      await container.read(titleWarningPrefProvider.future);

      // Act
      await container.read(titleWarningPrefProvider.notifier).dontShowAgain();

      // Verify
      expect(container.read(titleWarningPrefProvider).value, isFalse);
      expect(repository.getPref(), isFalse);
    });
  });
}
