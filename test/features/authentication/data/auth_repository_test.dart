import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/authentication/data/auth_repository.dart';
import 'package:private_notes_light/features/authentication/domain/credentials_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('AuthRepository.saveCredentials works', () async {
    // Setup
    SharedPreferences.setMockInitialValues({});
    final dummyCredentials = CredentialsData(
      salt: 'salt',
      iv: 'iv',
      encryptedMasterKey: 'encryptedMasterKey',
    );

    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Act
    await container.read(authRepositoryProvider).saveCredentials(dummyCredentials);

    // Verify
    final prefs = await SharedPreferences.getInstance();
    final savedSalt = prefs.getString(CredentialsData.propertyNames.salt);
    final savedIv = prefs.getString(CredentialsData.propertyNames.iv);
    final savedEncryptedMasterKey = prefs.getString(
      CredentialsData.propertyNames.encryptedMasterKey,
    );

    expect(savedSalt, isNotNull);
    expect(savedIv, isNotNull);
    expect(savedEncryptedMasterKey, isNotNull);
  });

  test('AuthRepository.readCredentials works', () async {
    // Setup
    SharedPreferences.setMockInitialValues({});
    final dummyCredentials = CredentialsData(
      salt: 'salt',
      iv: 'iv',
      encryptedMasterKey: 'encryptedMasterKey',
    );

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(authRepositoryProvider).saveCredentials(dummyCredentials);

    // Act
    final loadedCredentials = await container.read(authRepositoryProvider).readCredentials();

    // Verify
    expect(loadedCredentials, isA<CredentialsData>());
  });

  group('AuthRepository.userSignedUp works', () {
    test(
      'AuthRepository.userSignedUp returns false if encryptedMasterKey is not present in shared_preferences',
      () async {
        // Setup
        SharedPreferences.setMockInitialValues({});

        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Act
        final userSignedUp = await container.read(authRepositoryProvider).userSignedUp;

        // Verify
        expect(userSignedUp, isFalse);
      },
    );

    test(
      'AuthRepository.userSignedUp returns true if encryptedMasterKey is present in shared_preferences',
      () async {
        // Setup
        SharedPreferences.setMockInitialValues({
          CredentialsData.propertyNames.encryptedMasterKey: 'dummyValue',
        });

        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Act
        final userSignedUp = await container.read(authRepositoryProvider).userSignedUp;

        // Verify
        expect(userSignedUp, isTrue);
      },
    );
  });
}
