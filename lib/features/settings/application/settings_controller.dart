import 'package:flutter/material.dart';
import 'package:private_notes_light/features/settings/domain/settings_data.dart';
import 'package:private_notes_light/features/settings/data/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  Future<SettingsData> build() async {
    final settingsRepo = await ref.watch(settingsRepositoryProvider.future);

    return settingsRepo.getSettings();
  }

  Future<void> setExportSuggestions(bool newValue) async {
    final settingsRepo = await ref.watch(settingsRepositoryProvider.future);
    await settingsRepo.setExportSuggestions(newValue);

    final previous = state.value!;
    state = AsyncData(
      SettingsData(
        exportSuggestions: newValue,
        exportWarnings: previous.exportWarnings,
        theme: previous.theme,
      ),
    );
  }

  Future<void> setExportWarnings(bool newValue) async {
    final settingsRepo = await ref.watch(settingsRepositoryProvider.future);
    await settingsRepo.setExportWarnings(newValue);

    final previous = state.value!;
    state = AsyncData(
      SettingsData(
        exportSuggestions: previous.exportSuggestions,
        exportWarnings: newValue,
        theme: previous.theme,
      ),
    );
  }

  Future<void> setTheme(ThemeMode newTheme) async {
    final settingsRepo = await ref.watch(settingsRepositoryProvider.future);
    await settingsRepo.setTheme(newTheme);

    final previous = state.value!;
    state = AsyncData(
      SettingsData(
        exportSuggestions: previous.exportSuggestions,
        exportWarnings: previous.exportWarnings,
        theme: newTheme,
      ),
    );
  }
}
