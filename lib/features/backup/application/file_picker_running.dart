import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'file_picker_running.g.dart';

@Riverpod(keepAlive: true)
class FilePickerRunning extends _$FilePickerRunning {
  @override
  bool build() => false;

  void set(bool newValue) => state = newValue;
}
