import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:private_notes_light/features/settings/domain/settings_data.dart';
import 'package:private_notes_light/features/settings/domain/sorting_option.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_repository.g.dart';

class SettingsRepository {
  final SharedPreferences pref;
  SettingsRepository(this.pref);

  SettingsData getSettings() {
    final defaultValues = SettingsData();
    final bool? exportSuggestionsPref = pref.getBool(SettingsData.propertyNames.exportSuggestions);

    if (exportSuggestionsPref == null) {
      importSettings(defaultValues);
      return defaultValues;
    } else {
      final bool exportWarningsPref = pref.getBool(SettingsData.propertyNames.exportWarnings)!;
      final String themePref = pref.getString(SettingsData.propertyNames.theme)!;
      final String sortingOptionPref = pref.getString(SettingsData.propertyNames.sortingOption)!;

      return SettingsData(
        exportSuggestions: exportSuggestionsPref,
        exportWarnings: exportWarningsPref,
        theme: ThemeMode.values.byName(themePref),
        sortingOption: SortingOption.values.byName(sortingOptionPref),
      );
    }
  }

  Future<void> importSettings(SettingsData settingsData) async {
    await setExportSuggestions(settingsData.exportSuggestions);
    await setExportWarnings(settingsData.exportWarnings);
    await setTheme(settingsData.theme);
    await setSortingOption(settingsData.sortingOption);
  }

  Future<void> setExportSuggestions(bool newValue) async => await pref.setBool(SettingsData.propertyNames.exportSuggestions, newValue);
  Future<void> setExportWarnings(bool newValue) async => await pref.setBool(SettingsData.propertyNames.exportWarnings, newValue);
  Future<void> setTheme(ThemeMode newValue) async => await pref.setString(SettingsData.propertyNames.theme, newValue.name);
  Future<void> setSortingOption(SortingOption newValue) async => await pref.setString(SettingsData.propertyNames.sortingOption, newValue.name);
}

@riverpod
Future<SettingsRepository> settingsRepository(Ref ref) async => SettingsRepository(await SharedPreferences.getInstance());
