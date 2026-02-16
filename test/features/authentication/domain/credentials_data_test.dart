import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/authentication/domain/credentials_data.dart';

void main() {
  final dummyCredentials = CredentialsData(
    salt: 'salt',
    iv: 'iv',
    encryptedMasterKey: 'encryptedMasterKey',
  );

  test('Credentials data serializes', () {
    final dummyCredentialsJson = dummyCredentials.toJson();

    expect(dummyCredentialsJson, isA<Map<String, dynamic>>());
  });

  test('Credentials data deserializes', () {
    final dummyCredentialsJson = dummyCredentials.toJson();
    final deSerializedDummyCredentials = CredentialsData.fromJson(dummyCredentialsJson);

    expect(deSerializedDummyCredentials, isA<CredentialsData>());
    expect(deSerializedDummyCredentials.encryptedMasterKey, dummyCredentials.encryptedMasterKey);
    expect(deSerializedDummyCredentials.iv, dummyCredentials.iv);
    expect(deSerializedDummyCredentials.salt, dummyCredentials.salt);
  });

  test('CredentialsData class has propertyNames', () {
    final propertyNames = CredentialsData.propertyNames;

    expect(propertyNames, isA<({String encryptedMasterKey, String iv, String salt})>());
  });
}
