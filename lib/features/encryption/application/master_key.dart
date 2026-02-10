import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'master_key.g.dart';

@Riverpod(keepAlive: true)
class MasterKey extends _$MasterKey {
  @override
  String? build() => null;

  void set(String newValue) => state = newValue;

  void clear() => state = '';
}
