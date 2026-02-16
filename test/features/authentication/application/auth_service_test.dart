import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:private_notes_light/features/authentication/application/auth_service.dart';
import 'package:private_notes_light/features/authentication/data/auth_repository.dart';
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

  test('AuthService.signup works', () async {
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
}
