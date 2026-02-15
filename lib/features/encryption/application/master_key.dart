import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:encrypt/encrypt.dart' as enc;

part 'master_key.g.dart';

@Riverpod(keepAlive: true)
class MasterKey extends _$MasterKey {
  @override
  enc.Key? build() => null;

  void set(enc.Key newValue) => state = newValue;

  void clear() => state = null;
}
