import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/encryption/application/encryption_service.dart';
import 'package:private_notes_light/features/encryption/application/master_key.dart';
import 'package:encrypt/encrypt.dart' as enc;

void main() {
  late ProviderContainer container;
  late EncryptionService encryptionService;

  setUp(() {
    container = ProviderContainer();
    encryptionService = container.read(encryptionServiceProvider);
    addTearDown(container.dispose);
  });

  test('generateRandomBytes returns requested number of bytes', () {
    // Act
    final bytes = encryptionService.generateRandomBytes(32);

    // Verify
    expect(bytes.length, 32);
    expect(bytes.every((byte) => byte >= 0 && byte <= 255), isTrue);
  });

  test('generateSalt returns random values', () {
    // Act
    final salt1 = encryptionService.generateSalt();
    final salt2 = encryptionService.generateSalt();

    // Verify
    expect(salt1, isNotEmpty);
    expect(salt2, isNotEmpty);
    expect(salt1, isNot(salt2));
  });

  test('deriveKeyFromPassword returns a 32-byte key', () async {
    // Act
    final key = await encryptionService.deriveKeyFromPassword('password', 'salt');

    // Verify
    expect(key.bytes.length, 32);
  });

  test('encryptText aligns with decryptText', () {
    // Setup
    final dummyKey = enc.Key.fromLength(32);
    final dummyIv = enc.IV.fromLength(16);
    const dummyText = 'dummyText';

    // Act
    final encrypted = encryptionService.encryptText(text: dummyText, key: dummyKey, iv: dummyIv);
    final decryptedText = encryptionService.decryptText(encryptedText: encrypted.encryptedText, key: dummyKey, iv: encrypted.encryptionIV);

    // Verify
    expect(encrypted.encryptionIV, dummyIv);
    expect(decryptedText, dummyText);
  });

  test('keyCanDecrypt returns true for the correct key and false for a wrong key', () {
    // Setup
    final correctKey = enc.Key.fromLength(32);
    final wrongKey = enc.Key.fromUtf8('11111111111111111111111111111111');
    final encrypted = encryptionService.encryptText(text: 'dummyText', key: correctKey);

    // Act & Verify
    expect(encryptionService.keyCanDecrypt(encrypted.encryptedText, correctKey, encrypted.encryptionIV), isTrue);
    expect(encryptionService.keyCanDecrypt(encrypted.encryptedText, wrongKey, encrypted.encryptionIV), isFalse);
  });

  test('encryption aligns with decryption', () {
    // Setup
    final dummyKey = enc.Key.fromLength(32);
    container.read(masterKeyProvider.notifier).set(dummyKey);

    final dummyText = 'dummyText';

    // Act
    final encrypted = container.read(encryptionServiceProvider).encryptWithMasterKey(dummyText);
    final decryptedText = container.read(encryptionServiceProvider).decryptWithMasterKey(encrypted.encryptedText, encrypted.encryptionIV);

    // Verify
    expect(decryptedText, dummyText);
  });
}
