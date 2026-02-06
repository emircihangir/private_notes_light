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
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> saveCredentials({
    required String salt,
    required String iv,
    required String encryptedMasterKey,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_salt', salt);
    await prefs.setString('auth_master_key_iv', iv);
    await prefs.setString('auth_encrypted_master_key', encryptedMasterKey);
  }

  @override
  Future<bool> get userSignedUp async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('auth_encrypted_master_key');
  }
}

@riverpod
AuthRepositoryImpl authRepository(Ref ref) => AuthRepositoryImpl();
