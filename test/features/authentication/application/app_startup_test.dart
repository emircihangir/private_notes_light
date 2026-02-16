import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:private_notes_light/features/authentication/application/app_startup.dart';
import 'package:private_notes_light/features/authentication/data/auth_repository.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>()])
import 'app_startup_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  group('appStartupProvider aligns with authRepositoryProvider', () {
    test('appStartupProvider returns true if the user is signed up', () async {
      // * Stub mockAuthRepository.
      when(mockAuthRepository.userSignedUp).thenAnswer((_) async => true);

      // * Setup the container.
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(mockAuthRepository)],
      );
      addTearDown(container.dispose);

      final result = await container.read(appStartupProvider.future);

      expect(result, true);
      verify(mockAuthRepository.userSignedUp).called(1);
    });

    test('appStartupProvider returns false if the user is not signed up', () async {
      // * Stub mockAuthRepository.
      when(mockAuthRepository.userSignedUp).thenAnswer((_) async => false);

      // * Setup the container.
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(mockAuthRepository)],
      );
      addTearDown(container.dispose);

      final result = await container.read(appStartupProvider.future);

      expect(result, false);
      verify(mockAuthRepository.userSignedUp).called(1);
    });
  });
}
