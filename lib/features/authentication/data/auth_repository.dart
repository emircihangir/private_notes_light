import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/authentication/domain/credentials_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_repository.g.dart';

abstract class AuthRepository {
  Future<bool> get userSignedUp;
  Future<void> saveCredentials(CredentialsData credentialsData);
  Future<CredentialsData> readCredentials();
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> saveCredentials(CredentialsData credentialsData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(CredentialsData.propertyNames.salt, credentialsData.salt);
    await prefs.setString(CredentialsData.propertyNames.iv, credentialsData.iv);
    await prefs.setString(
      CredentialsData.propertyNames.encryptedMasterKey,
      credentialsData.encryptedMasterKey,
    );
  }

  @override
  Future<bool> get userSignedUp async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(CredentialsData.propertyNames.encryptedMasterKey);
  }

  @override
  Future<CredentialsData> readCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return CredentialsData(
      salt: prefs.getString(CredentialsData.propertyNames.salt)!,
      iv: prefs.getString(CredentialsData.propertyNames.iv)!,
      encryptedMasterKey: prefs.getString(CredentialsData.propertyNames.encryptedMasterKey)!,
    );
  }
}

@riverpod
AuthRepositoryImpl authRepository(Ref ref) => AuthRepositoryImpl();
