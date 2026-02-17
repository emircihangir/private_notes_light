import 'dart:convert';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/encryption/application/master_key.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:encrypt/encrypt.dart' as enc;

part 'encryption_service.g.dart';

class EncryptionService {
  final Ref ref;
  EncryptionService(this.ref);

  String generateSalt() => base64Url.encode(generateRandomBytes(16));

  Future<enc.Key> deriveKeyFromPassword(String password, String salt) async {
    var passwordBytes = utf8.encode(password);
    var saltBytes = utf8.encode(salt);
    return await compute(deriveKeyBackground, {
      'passwordBytes': passwordBytes,
      'saltBytes': saltBytes,
    });
  }

  List<int> generateRandomBytes(int length) {
    final random = Random.secure();
    return List<int>.generate(length, (i) => random.nextInt(256));
  }

  ({String encryptedText, String encryptionIV}) encryptWithMasterKey(String text, {enc.IV? iv}) {
    final key = ref.read(masterKeyProvider)!;
    final encrypter = enc.Encrypter(enc.AES(key));
    final enc.IV ivValue = iv ?? enc.IV.fromLength(16);
    final encrypted = encrypter.encrypt(text, iv: ivValue);
    return (encryptedText: encrypted.base64, encryptionIV: ivValue.base64);
  }

  ({String encryptedText, String encryptionIV}) encryptText({
    required String text,
    required enc.Key key,
    enc.IV? iv,
  }) {
    final encrypter = enc.Encrypter(enc.AES(key));
    final enc.IV ivValue = iv ?? enc.IV.fromLength(16);
    final encrypted = encrypter.encrypt(text, iv: ivValue);
    return (encryptedText: encrypted.base64, encryptionIV: ivValue.base64);
  }

  String decryptText({required String encryptedText, required enc.Key key, required enc.IV iv}) {
    final encrypter = enc.Encrypter(enc.AES(key));
    return encrypter.decrypt(enc.Encrypted.fromBase64(encryptedText), iv: iv);
  }

  bool keyCanDecrypt(String text, enc.Key key, enc.IV iv) {
    // * Try to decrypt first note's content with key.
    try {
      decryptText(encryptedText: text, key: key, iv: iv);
      return true;
    } catch (e) {
      return false;
    }
  }

  String decryptWithMasterKey(String encryptedText, enc.IV iv) {
    final key = ref.read(masterKeyProvider)!;

    final encrypter = enc.Encrypter(enc.AES(key));
    return encrypter.decrypt(enc.Encrypted.fromBase64(encryptedText), iv: iv);
  }
}

Future<enc.Key> deriveKeyBackground(Map<String, Uint8List> args) async {
  final passwordBytes = args['passwordBytes']!;
  final saltBytes = args['saltBytes']!;

  final algorithm = Argon2id(
    parallelism: 4,
    memory: 16000, // 16MB
    iterations: 3,
    hashLength: 32,
  );

  final newSecretKey = await algorithm.deriveKey(
    secretKey: SecretKey(passwordBytes),
    nonce: saltBytes,
  );
  final newSecretKeyBytes = await newSecretKey.extractBytes();

  return enc.Key(Uint8List.fromList(newSecretKeyBytes));
}

@riverpod
EncryptionService encryptionService(Ref ref) => EncryptionService(ref);
