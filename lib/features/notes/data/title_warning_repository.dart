import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'title_warning_repository.g.dart';

class TitleWarningRepository {
  SharedPreferences prefs;
  static const _key = 'titleWarningKey';
  TitleWarningRepository(this.prefs);

  bool getPref() {
    return prefs.getBool(_key) ?? true;
  }

  Future<void> setPref(bool newValue) async {
    await prefs.setBool(_key, newValue);
  }
}

@riverpod
Future<TitleWarningRepository> titleWarningRepository(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return TitleWarningRepository(prefs);
}
