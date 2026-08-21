import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:private_notes_light/features/settings/application/settings_controller.dart';
import 'package:private_notes_light/features/settings/data/settings_repository.dart';
import 'package:private_notes_light/features/settings/domain/settings_data.dart';
import 'package:private_notes_light/features/settings/domain/sorting_option.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late FakeSettingsRepository repository;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repository = FakeSettingsRepository(prefs, SettingsData());
    container = ProviderContainer(overrides: [settingsRepositoryProvider.overrideWith((ref) async => repository)]);
    addTearDown(container.dispose);
  });

  group('SettingsController tests ->', () {
    test('build returns repository settings', () async {
      // Setup
      repository.settings = SettingsData(
        exportSuggestions: false,
        exportWarnings: false,
        theme: ThemeMode.dark,
        sortingOption: SortingOption.aToZ,
      );

      // Act
      final settings = await container.read(settingsControllerProvider.future);

      // Verify
      expect(settings, repository.settings);
    });

    test('setExportSuggestions persists and updates state', () async {
      // Setup
      await container.read(settingsControllerProvider.future);

      // Act
      await container.read(settingsControllerProvider.notifier).setExportSuggestions(false);

      // Verify
      expect(repository.exportSuggestionsSetTo, false);
      expect(container.read(settingsControllerProvider).value!.exportSuggestions, isFalse);
    });

    test('setExportWarnings persists and updates state', () async {
      // Setup
      await container.read(settingsControllerProvider.future);

      // Act
      await container.read(settingsControllerProvider.notifier).setExportWarnings(false);

      // Verify
      expect(repository.exportWarningsSetTo, false);
      expect(container.read(settingsControllerProvider).value!.exportWarnings, isFalse);
    });

    test('setTheme persists and updates state', () async {
      // Setup
      await container.read(settingsControllerProvider.future);

      // Act
      await container.read(settingsControllerProvider.notifier).setTheme(ThemeMode.dark);

      // Verify
      expect(repository.themeSetTo, ThemeMode.dark);
      expect(container.read(settingsControllerProvider).value!.theme, ThemeMode.dark);
    });

    test('setSortingOption persists and updates state', () async {
      // Setup
      await container.read(settingsControllerProvider.future);

      // Act
      await container.read(settingsControllerProvider.notifier).setSortingOption(SortingOption.aToZ);

      // Verify
      expect(repository.sortingOptionSetTo, SortingOption.aToZ);
      expect(container.read(settingsControllerProvider).value!.sortingOption, SortingOption.aToZ);
    });
  });
}

class FakeSettingsRepository extends SettingsRepository {
  SettingsData settings;
  bool? exportSuggestionsSetTo;
  bool? exportWarningsSetTo;
  ThemeMode? themeSetTo;
  SortingOption? sortingOptionSetTo;

  FakeSettingsRepository(super.pref, this.settings);

  @override
  SettingsData getSettings() => settings;

  @override
  Future<void> setExportSuggestions(bool newValue) async {
    exportSuggestionsSetTo = newValue;
    settings = settings.copyWith(exportSuggestions: newValue);
  }

  @override
  Future<void> setExportWarnings(bool newValue) async {
    exportWarningsSetTo = newValue;
    settings = settings.copyWith(exportWarnings: newValue);
  }

  @override
  Future<void> setTheme(ThemeMode newValue) async {
    themeSetTo = newValue;
    settings = settings.copyWith(theme: newValue);
  }

  @override
  Future<void> setSortingOption(SortingOption newValue) async {
    sortingOptionSetTo = newValue;
    settings = settings.copyWith(sortingOption: newValue);
  }
}
