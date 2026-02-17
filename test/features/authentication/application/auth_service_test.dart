import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:private_notes_light/features/authentication/application/auth_service.dart';
import 'package:private_notes_light/features/authentication/data/auth_repository.dart';
import 'package:private_notes_light/features/authentication/domain/credentials_data.dart';
import 'package:private_notes_light/features/encryption/application/encryption_service.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:private_notes_light/features/encryption/application/master_key.dart';

@GenerateNiceMocks([MockSpec<AuthRepository>(), MockSpec<EncryptionService>()])
import 'auth_service_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockEncryptionService mockEncryptionService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockEncryptionService = MockEncryptionService();
  });
  group('AuthService Tests', () {
    test('signup works', () async {
      // Setup
      const dummyPassword = 'dummyPassword';
      const dummySalt = 'dummySalt';
      final enc.Key dummyUserKey = enc.Key.fromLength(32);
      final dummyBytes = List<int>.filled(32, 1);
      final dummyMasterKey = enc.Key(Uint8List.fromList(dummyBytes));
      const dummyEncryptedText = 'dummyEncryptedText';
      const dummyEncryptionIV = 'dummyEncryptionIV';

      when(mockEncryptionService.generateSalt()).thenReturn(dummySalt);
      when(
        mockEncryptionService.deriveKeyFromPassword(dummyPassword, dummySalt),
      ).thenAnswer((_) async => dummyUserKey);
      when(mockEncryptionService.generateRandomBytes(32)).thenReturn(dummyBytes);
      when(
        mockEncryptionService.encryptText(text: dummyMasterKey.base64, key: dummyUserKey),
      ).thenReturn((encryptedText: dummyEncryptedText, encryptionIV: dummyEncryptionIV));

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          encryptionServiceProvider.overrideWithValue(mockEncryptionService),
        ],
      );
      addTearDown(container.dispose);

      // Act
      await container.read(authServiceProvider).signup(dummyPassword);

      // Verify
      verify(mockAuthRepository.saveCredentials(any)).called(1);

      final masterKey = container.read(masterKeyProvider);
      expect(
        masterKey,
        isNotNull,
        reason: 'Master key must be non-null after AuthService.signup is called.',
      );
    });

    group('login works', () {
      test('returns true and sets master key when password is correct', () async {
        // Setup
        const password = 'correct_password';
        final validMasterKeyString = enc.Key.fromLength(32).base64;
        final dummyIV = enc.IV.fromLength(16);
        final dummyCredentials = CredentialsData(
          salt: 'salt',
          iv: dummyIV.base64,
          encryptedMasterKey: 'encrypted_content',
        );
        final derivedKey = enc.Key.fromLength(32);

        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockAuthRepository),
            encryptionServiceProvider.overrideWithValue(mockEncryptionService),
          ],
        );
        addTearDown(container.dispose);

        when(mockAuthRepository.readCredentials()).thenAnswer((_) async => dummyCredentials);

        when(
          mockEncryptionService.deriveKeyFromPassword(password, dummyCredentials.salt),
        ).thenAnswer((_) async => derivedKey);

        when(
          mockEncryptionService.decryptText(
            encryptedText: dummyCredentials.encryptedMasterKey,
            key: derivedKey,
            iv: dummyIV,
          ),
        ).thenReturn(validMasterKeyString);

        // Act
        final result = await container.read(authServiceProvider).login(password);

        // Verify
        expect(result, isTrue);
        final setMasterKey = container.read(masterKeyProvider);
        expect(setMasterKey, isNotNull);
        expect(setMasterKey!.base64, validMasterKeyString);
      });

      test('returns false and does not set master key when password is wrong', () async {
        // 1. Setup Data
        const password = 'wrong_password';
        final dummyCredentials = CredentialsData(
          salt: 'salt',
          iv: 'iv',
          encryptedMasterKey: 'encrypted_content',
        );
        final derivedKey = enc.Key.fromLength(32);

        // 2. Setup Container
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(mockAuthRepository),
            encryptionServiceProvider.overrideWithValue(mockEncryptionService),
          ],
        );
        addTearDown(container.dispose);

        // 3. Mock Interactions
        when(mockAuthRepository.readCredentials()).thenAnswer((_) async => dummyCredentials);

        when(
          mockEncryptionService.deriveKeyFromPassword(password, dummyCredentials.salt),
        ).thenAnswer((_) async => derivedKey);

        // Step C: Simulate decryption failure (Exception)
        when(
          mockEncryptionService.decryptText(
            encryptedText: dummyCredentials.encryptedMasterKey,
            key: derivedKey,
            iv: anyNamed('iv'),
          ),
        ).thenThrow(Exception('Decryption failed: MAC check failed'));

        // 4. Act
        final result = await container.read(authServiceProvider).login(password);

        // 5. Verify
        expect(result, isFalse);

        // Verify master key is NOT set
        expect(container.read(masterKeyProvider), isNull);
      });
    });

    test('logout clears master key provider', () {
      final container = ProviderContainer();
      container.read(authServiceProvider).logout();

      expect(container.read(masterKeyProvider), isNull);
    });

    test('changeMasterPassword works', () async {
      // Setup
      final container = ProviderContainer(
        overrides: [
          encryptionServiceProvider.overrideWith((_) => mockEncryptionService),
          authRepositoryProvider.overrideWith((_) => mockAuthRepository),
        ],
      );
      addTearDown(container.dispose);

      final dummyMasterKey = enc.Key.fromLength(32);
      container.read(masterKeyProvider.notifier).set(dummyMasterKey);

      final dummySalt = 'dummySalt';
      when(mockEncryptionService.generateSalt()).thenReturn(dummySalt);

      final dummyPassword = 'dummyPassword';
      final dummyDerivedKey = enc.Key.fromLength(32);
      when(
        mockEncryptionService.deriveKeyFromPassword(dummyPassword, dummySalt),
      ).thenAnswer((_) async => dummyDerivedKey);

      final dummyEncryptedText = 'dummyEncryptedText';
      final dummyIv = enc.IV.fromLength(16);
      final dummyReturnValue = (encryptedText: dummyEncryptedText, encryptionIV: dummyIv.base64);
      when(
        mockEncryptionService.encryptText(text: dummyMasterKey.base64, key: dummyDerivedKey),
      ).thenReturn(dummyReturnValue);

      // Act
      await container.read(authServiceProvider).changeMasterPassword(dummyPassword);

      // Verify
      verify(
        mockAuthRepository.saveCredentials(
          CredentialsData(
            salt: dummySalt,
            iv: dummyIv.base64,
            encryptedMasterKey: dummyEncryptedText,
          ),
        ),
      ).called(1);
    });
  });
}
