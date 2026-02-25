import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/encryption/application/encryption_service.dart';
import 'package:private_notes_light/features/encryption/application/master_key.dart';
import 'package:encrypt/encrypt.dart' as enc;

void main() {
  test('encryption aligns with decryption', () {
    // Setup
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final dummyKey = enc.Key.fromLength(32);
    container.read(masterKeyProvider.notifier).set(dummyKey);

    final dummyText = 'dummyText';

    // Act
    final encrypted = container.read(encryptionServiceProvider).encryptWithMasterKey(dummyText);
    final decryptedText = container
        .read(encryptionServiceProvider)
        .decryptWithMasterKey(encrypted.encryptedText, encrypted.encryptionIV);

    // Verify
    expect(decryptedText, dummyText);
  });
}
