import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<bool> get userSignedUp;
  Future<void> saveCredentials({
    required String salt,
    required String iv,
    required String encryptedMasterKey,
  });
  Future<Map<String, String>> readCredentials();
}

class AuthRepositoryImpl implements AuthRepository {
  final String saltKey = 'auth_salt';
  final String ivKey = 'auth_master_key_iv';
  final String encryptedMasterKeyKey = 'auth_encrypted_master_key';

  @override
  Future<void> saveCredentials({
    required String salt,
    required String iv,
    required String encryptedMasterKey,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(saltKey, salt);
    await prefs.setString(ivKey, iv);
    await prefs.setString(encryptedMasterKeyKey, encryptedMasterKey);
  }

  @override
  Future<bool> get userSignedUp async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(encryptedMasterKeyKey);
  }

  @override
  Future<Map<String, String>> readCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      saltKey: prefs.getString(saltKey)!,
      ivKey: prefs.getString(ivKey)!,
      encryptedMasterKeyKey: prefs.getString(encryptedMasterKeyKey)!,
    };
  }
}

@riverpod
AuthRepositoryImpl authRepository(Ref ref) => AuthRepositoryImpl();
