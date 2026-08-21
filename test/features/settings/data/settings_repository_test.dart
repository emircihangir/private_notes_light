import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/settings/data/settings_repository.dart';
import 'package:private_notes_light/features/settings/domain/settings_data.dart';
import 'package:private_notes_light/features/settings/domain/sorting_option.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsRepository tests ->', () {
    test('getSettings returns defaults when preferences are empty', () async {
      // Setup
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repository = SettingsRepository(prefs);

      // Act
      final settings = repository.getSettings();

      // Verify
      expect(settings, SettingsData());
    });

    test('getSettings reads stored settings', () async {
      // Setup
      SharedPreferences.setMockInitialValues({
        SettingsData.propertyNames.exportSuggestions: false,
        SettingsData.propertyNames.exportWarnings: false,
        SettingsData.propertyNames.theme: ThemeMode.dark.name,
        SettingsData.propertyNames.sortingOption: SortingOption.aToZ.name,
      });
      final prefs = await SharedPreferences.getInstance();
      final repository = SettingsRepository(prefs);

      // Act
      final settings = repository.getSettings();

      // Verify
      expect(settings.exportSuggestions, isFalse);
      expect(settings.exportWarnings, isFalse);
      expect(settings.theme, ThemeMode.dark);
      expect(settings.sortingOption, SortingOption.aToZ);
    });

    test('importSettings persists all settings', () async {
      // Setup
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final repository = SettingsRepository(prefs);
      final settings = SettingsData(
        exportSuggestions: false,
        exportWarnings: false,
        theme: ThemeMode.light,
        sortingOption: SortingOption.zToA,
      );

      // Act
      await repository.importSettings(settings);

      // Verify
      expect(repository.getSettings(), settings);
    });

    test('individual setters persist their values', () async {
      // Setup
      SharedPreferences.setMockInitialValues({
        SettingsData.propertyNames.exportSuggestions: true,
        SettingsData.propertyNames.exportWarnings: true,
        SettingsData.propertyNames.theme: ThemeMode.system.name,
        SettingsData.propertyNames.sortingOption: SortingOption.newestFirst.name,
      });
      final prefs = await SharedPreferences.getInstance();
      final repository = SettingsRepository(prefs);

      // Act
      await repository.setExportSuggestions(false);
      await repository.setExportWarnings(false);
      await repository.setTheme(ThemeMode.dark);
      await repository.setSortingOption(SortingOption.oldestFirst);

      // Verify
      final settings = repository.getSettings();
      expect(settings.exportSuggestions, isFalse);
      expect(settings.exportWarnings, isFalse);
      expect(settings.theme, ThemeMode.dark);
      expect(settings.sortingOption, SortingOption.oldestFirst);
    });
  });
}
