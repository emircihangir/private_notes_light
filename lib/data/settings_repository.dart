import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_repository.g.dart';

typedef SettingsRecord = ({bool autoExport, String? brightness});

abstract class SettingsRepository {
  SettingsRecord getSettings();
  void setAutoExport(bool newValue);
  void setBrightness(String? newValue);
}

class SettingsRepositoryImpl implements SettingsRepository {
  static const autoExportKey = 'autoExport';
  static const brightnessKey = 'brightness';
  final SharedPreferences pref;

  SettingsRepositoryImpl(this.pref);

  @override
  SettingsRecord getSettings() {
    final bool? autoExportPref = pref.getBool(autoExportKey);
    final String? brightnessPref = pref.getString(brightnessKey);

    if (autoExportPref == null) setAutoExport(true);

    return (autoExport: autoExportPref ?? true, brightness: brightnessPref);
  }

  @override
  Future<void> setAutoExport(bool newValue) async {
    await pref.setBool(autoExportKey, newValue);
  }

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
