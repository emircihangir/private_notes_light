import 'package:flutter/services.dart';
import 'package:private_notes_light/application/encryption_service.dart';
import 'package:private_notes_light/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:encrypt/encrypt.dart' as enc;

part 'auth_service.g.dart';

@riverpod
class AuthService extends _$AuthService {
  @override
  FutureOr<void> build() {}

  Future<void> signup(String masterPassword) async {
    final salt = ref.read(encryptionServiceProvider.notifier).generateSalt();
    final userKey = await ref
        .read(encryptionServiceProvider.notifier)
        .deriveKeyFromPassword(masterPassword, salt);

    // * Generate random master key.
    final masterKeyBytes = ref.read(encryptionServiceProvider.notifier).generateRandomBytes(32);
    final masterKey = enc.Key(Uint8List.fromList(masterKeyBytes));

    // * Encrypt the generated master key.
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(userKey));
    final encryptedMasterKey = encrypter.encrypt(masterKey.base64, iv: iv);

    // * Save the encrypted master key along with salt and iv.
    await ref
        .read(authRepositoryProvider)
        .saveCredentials(salt: salt, iv: iv.base64, encryptedMasterKey: encryptedMasterKey.base64);
  }
}
