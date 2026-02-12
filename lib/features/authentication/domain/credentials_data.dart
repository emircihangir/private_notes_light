import 'package:freezed_annotation/freezed_annotation.dart';

part 'credentials_data.freezed.dart';
part 'credentials_data.g.dart';

@freezed
abstract class CredentialsData with _$CredentialsData {
  factory CredentialsData({
    required String salt,
    required String iv,
    required String encryptedMasterKey,
  }) = _CredentialsData;

  CredentialsData._();

  factory CredentialsData.fromJson(Map<String, Object?> json) => _$CredentialsDataFromJson(json);

  static const propertyNames = (salt: 'salt', iv: 'iv', encryptedMasterKey: 'encryptedMasterKey');
}
