import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
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
}

enc.Key deriveKeyBackground(Uint8List bytes) {
  var digest = sha256.convert(bytes);
  for (var i = 0; i < 100000; i++) {
    digest = sha256.convert(digest.bytes);
  }
  return enc.Key(Uint8List.fromList(digest.bytes));
}
