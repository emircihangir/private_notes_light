import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:private_notes_light/application/master_key.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:encrypt/encrypt.dart' as enc;

part 'encryption_service.g.dart';

@riverpod
class EncryptionService extends _$EncryptionService {
  @override
  void build() {}

  String generateSalt() => base64Url.encode(generateRandomBytes(16));

  Future<enc.Key> deriveKeyFromPassword(String password, String salt) async {
    var bytes = utf8.encode(password + salt);
    return await compute(deriveKeyBackground, bytes);
  }

  List<int> generateRandomBytes(int length) {
    final random = Random.secure();
    return List<int>.generate(length, (i) => random.nextInt(256));
  }

  ({String encryptedText, String encryptionIV}) encryptWithMasterKey(String text, {enc.IV? iv}) {
    final keyString = ref.read(masterKeyProvider);
    final key = enc.Key.fromBase64(keyString!);
    final encrypter = enc.Encrypter(enc.AES(key));
    final enc.IV ivValue = iv ?? enc.IV.fromLength(16);
    final encrypted = encrypter.encrypt(text, iv: ivValue);
    return (encryptedText: encrypted.base64, encryptionIV: ivValue.base64);
  }

  ({String encryptedText, String encryptionIV}) encryptText(
    String text,
    String keyString, {
    enc.IV? iv,
  }) {
    final key = enc.Key.fromBase64(keyString);
    final encrypter = enc.Encrypter(enc.AES(key));
    final enc.IV ivValue = iv ?? enc.IV.fromLength(16);
    final encrypted = encrypter.encrypt(text, iv: ivValue);
    return (encryptedText: encrypted.base64, encryptionIV: ivValue.base64);
  }

  String decryptText(String encryptedText, String keyString, String ivString) {
    final encrypter = enc.Encrypter(enc.AES(enc.Key.fromBase64(keyString)));
    return encrypter.decrypt(
      enc.Encrypted.fromBase64(encryptedText),
      iv: enc.IV.fromBase64(ivString),
    );
  }
}

enc.Key deriveKeyBackground(Uint8List bytes) {
  var digest = sha256.convert(bytes);
  for (var i = 0; i < 100000; i++) {
    digest = sha256.convert(digest.bytes);
  }
  return enc.Key(Uint8List.fromList(digest.bytes));
}
