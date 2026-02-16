import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/authentication/domain/credentials_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  Future<void> saveCredentials(CredentialsData credentialsData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(CredentialsData.propertyNames.salt, credentialsData.salt);
    await prefs.setString(CredentialsData.propertyNames.iv, credentialsData.iv);
    await prefs.setString(
      CredentialsData.propertyNames.encryptedMasterKey,
      credentialsData.encryptedMasterKey,
    );
  }

  Future<bool> get userSignedUp async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(CredentialsData.propertyNames.encryptedMasterKey);
  }

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
AuthRepository authRepository(Ref ref) => AuthRepository();
