import 'package:flutter/services.dart';
import 'package:private_notes_light/features/authentication/domain/credentials_data.dart';
import 'package:private_notes_light/features/encryption/application/encryption_service.dart';
import 'package:private_notes_light/features/encryption/application/master_key.dart';
import 'package:private_notes_light/features/authentication/data/auth_repository.dart';
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
    var encrypted = ref
        .read(encryptionServiceProvider.notifier)
        .encryptText(masterKey.base64, userKey.base64);
    final encryptedMasterKeyString = encrypted.encryptedText;
    final encryptionIVstring = encrypted.encryptionIV;

    // * Save the encrypted master key along with salt and iv.
    await ref
        .read(authRepositoryProvider)
        .saveCredentials(
          CredentialsData(
            salt: salt,
            iv: encryptionIVstring,
            encryptedMasterKey: encryptedMasterKeyString,
          ),
        );

    ref.read(masterKeyProvider.notifier).set(masterKey.base64);
  }

  Future<bool> login(String passwordInput) async {
    final authRepository = ref.read(authRepositoryProvider);
    final CredentialsData credentialsData = await authRepository.readCredentials();

    final derivedKey = await ref
        .read(encryptionServiceProvider.notifier)
        .deriveKeyFromPassword(passwordInput, credentialsData.salt);

    try {
      final masterKey = ref
          .read(encryptionServiceProvider.notifier)
          .decryptText(credentialsData.encryptedMasterKey, derivedKey.base64, credentialsData.iv);

      ref.read(masterKeyProvider.notifier).set(masterKey);
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    ref.read(masterKeyProvider.notifier).clear();
  }
}
