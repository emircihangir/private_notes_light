import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/welcome/application/welcome_shown.dart';
import 'package:private_notes_light/features/welcome/data/welcome_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WelcomeRepository tests ->', () {
    test('isShown returns false by default', () async {
      // Setup
      SharedPreferences.setMockInitialValues({});
      final repository = WelcomeRepository();

      // Act & Verify
      expect(await repository.isShown, isFalse);
    });

    test('markShown persists shown state', () async {
      // Setup
      SharedPreferences.setMockInitialValues({});
      final repository = WelcomeRepository();

      // Act
      await repository.markShown();

      // Verify
      expect(await repository.isShown, isTrue);
    });

    test('provider returns repository', () {
      // Setup
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act & Verify
      expect(container.read(welcomeRepositoryProvider), isA<WelcomeRepository>());
    });
  });

  group('welcomeShownProvider tests ->', () {
    test('returns repository shown value', () async {
      // Setup
      final repository = FakeWelcomeRepository(isShownValue: true);
      final container = ProviderContainer(overrides: [welcomeRepositoryProvider.overrideWith((ref) => repository)]);
      addTearDown(container.dispose);

      // Act & Verify
      expect(await container.read(welcomeShownProvider.future), isTrue);
    });
  });
}

class FakeWelcomeRepository extends WelcomeRepository {
  final bool isShownValue;

  FakeWelcomeRepository({required this.isShownValue});

  @override
  Future<bool> get isShown async => isShownValue;
}
