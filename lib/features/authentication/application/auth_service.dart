import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/authentication/domain/credentials_data.dart';
import 'package:private_notes_light/features/encryption/application/encryption_service.dart';
import 'package:private_notes_light/features/encryption/application/master_key.dart';
import 'package:private_notes_light/features/authentication/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:encrypt/encrypt.dart' as enc;

part 'auth_service.g.dart';

class AuthService {
  final Ref ref;
  AuthService(this.ref);

  Future<void> signup(String masterPassword) async {
    // * Derive key from the password input.
    final salt = ref.read(encryptionServiceProvider).generateSalt();
    final userKey = await ref
        .read(encryptionServiceProvider)
        .deriveKeyFromPassword(masterPassword, salt);

    // * Generate random master key.
    final masterKeyBytes = ref.read(encryptionServiceProvider).generateRandomBytes(32);
    final masterKey = enc.Key(Uint8List.fromList(masterKeyBytes));

    // * Encrypt the generated master key.
    var encrypted = ref
        .read(encryptionServiceProvider)
        .encryptText(text: masterKey.base64, key: userKey);
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

    ref.read(masterKeyProvider.notifier).set(masterKey);
  }

  Future<void> changeMasterPassword(String newMasterPassword) async {
    final currentMasterKey = ref.read(masterKeyProvider);
    assert(
      currentMasterKey != null,
      "Master key must not be null when changeMasterPassword function is called",
    );

    // * Derive newUserKey from password input and newSalt.
    final newSalt = ref.read(encryptionServiceProvider).generateSalt();
    final newUserKey = await ref
        .read(encryptionServiceProvider)
        .deriveKeyFromPassword(newMasterPassword, newSalt);

    // * Encrypt currentMasterKey with newUserKey.
    var encrypted = ref
        .read(encryptionServiceProvider)
        .encryptText(text: currentMasterKey!.base64, key: newUserKey);
    final encryptedMasterKeyString = encrypted.encryptedText;
    final newIVstring = encrypted.encryptionIV;

    // * Save the newly encrypted master key.
    await ref
        .read(authRepositoryProvider)
        .saveCredentials(
          CredentialsData(
            salt: newSalt,
            iv: newIVstring,
            encryptedMasterKey: encryptedMasterKeyString,
          ),
        );
  }

  Future<bool> login(String passwordInput) async {
    final authRepository = ref.read(authRepositoryProvider);
    final CredentialsData credentialsData = await authRepository.readCredentials();

    final derivedKey = await ref
        .read(encryptionServiceProvider)
        .deriveKeyFromPassword(passwordInput, credentialsData.salt);

    try {
      final masterKeyString = ref
          .read(encryptionServiceProvider)
          .decryptText(
            encryptedText: credentialsData.encryptedMasterKey,
            key: derivedKey,
            iv: enc.IV.fromBase64(credentialsData.iv),
          );

      ref.read(masterKeyProvider.notifier).set(enc.Key.fromBase64(masterKeyString));
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    ref.read(masterKeyProvider.notifier).clear();
  }
}

@riverpod
AuthService authService(Ref ref) => AuthService(ref);
