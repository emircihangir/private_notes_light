// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credentials_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CredentialsData _$CredentialsDataFromJson(Map<String, dynamic> json) =>
    _CredentialsData(
      salt: json['salt'] as String,
      iv: json['iv'] as String,
      encryptedMasterKey: json['encryptedMasterKey'] as String,
    );

Map<String, dynamic> _$CredentialsDataToJson(_CredentialsData instance) =>
    <String, dynamic>{
      'salt': instance.salt,
      'iv': instance.iv,
      'encryptedMasterKey': instance.encryptedMasterKey,
    };
