import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/settings/domain/settings_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_repository.g.dart';

class SettingsRepository {
  final SharedPreferences pref;

  SettingsRepository(this.pref);

  SettingsData getSettings() {
    final bool? exportSuggestionsPref = pref.getBool(SettingsData.propertyNames.exportSuggestions);
    final bool? exportWarningsPref = pref.getBool(SettingsData.propertyNames.exportWarnings);
    final String? brightnessPref = pref.getString(SettingsData.propertyNames.theme);

    if (exportSuggestionsPref == null) setExportSuggestions(true);
    if (exportWarningsPref == null) setExportWarnings(true);

    return SettingsData(
      exportSuggestions: exportSuggestionsPref ?? true,
      exportWarnings: exportWarningsPref ?? true,
      theme: ThemeMode.values.byName(brightnessPref ?? ThemeMode.system.name),
    );
  }

  Future<void> importSettings(SettingsData settingsData) async {
    await setExportSuggestions(settingsData.exportSuggestions);
    await setExportWarnings(settingsData.exportWarnings);
    await setTheme(settingsData.theme);
  }

  Future<void> setExportSuggestions(bool newValue) async =>
      await pref.setBool(SettingsData.propertyNames.exportSuggestions, newValue);

  Future<void> setExportWarnings(bool newValue) async =>
      await pref.setBool(SettingsData.propertyNames.exportWarnings, newValue);

  Future<void> setTheme(ThemeMode newValue) async =>
      await pref.setString(SettingsData.propertyNames.theme, newValue.name);
}

@riverpod
Future<SettingsRepository> settingsRepository(Ref ref) async =>
    SettingsRepository(await SharedPreferences.getInstance());
