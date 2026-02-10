import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_repository.g.dart';

typedef SettingsRecord = ({bool exportSuggestions, bool exportWarnings, String? brightness});

abstract class SettingsRepository {
  SettingsRecord getSettings();
  void setExportSuggestions(bool newValue);
  void setExportWarnings(bool newValue);
  void setBrightness(String? newValue);
}

class SettingsRepositoryImpl implements SettingsRepository {
  static const exportSuggestionsKey = 'exportSuggestions';
  static const exportWarningsKey = 'exportWarnings';
  static const brightnessKey = 'brightness';
  final SharedPreferences pref;

  SettingsRepositoryImpl(this.pref);

  @override
  SettingsRecord getSettings() {
    final bool? exportSuggestionsPref = pref.getBool(exportSuggestionsKey);
    final bool? exportWarningsPref = pref.getBool(exportWarningsKey);
    final String? brightnessPref = pref.getString(brightnessKey);

    if (exportSuggestionsPref == null) setExportSuggestions(true);
    if (exportWarningsPref == null) setExportWarnings(true);

    return (
      exportSuggestions: exportSuggestionsPref ?? true,
      exportWarnings: exportWarningsPref ?? true,
      brightness: brightnessPref,
    );
  }

  @override
  Future<void> setExportSuggestions(bool newValue) async =>
      await pref.setBool(exportSuggestionsKey, newValue);

  @override
  Future<void> setExportWarnings(bool newValue) async =>
      await pref.setBool(exportWarningsKey, newValue);

  @override
  Future<void> setBrightness(String? newValue) async {
    if (newValue == null) {
      await pref.remove(brightnessKey);
    } else {
      await pref.setString(brightnessKey, newValue);
    }
  }
}

@riverpod
Future<SettingsRepositoryImpl> settingsRepository(Ref ref) async =>
    SettingsRepositoryImpl(await SharedPreferences.getInstance());
