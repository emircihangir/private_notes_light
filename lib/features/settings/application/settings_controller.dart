import 'package:flutter/material.dart';
import 'package:private_notes_light/features/settings/domain/settings_data.dart';
import 'package:private_notes_light/features/settings/data/settings_repository.dart';
import 'package:private_notes_light/features/settings/domain/sorting_option.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  Future<SettingsData> build() async {
    final settingsRepo = await ref.read(settingsRepositoryProvider.future);
    return settingsRepo.getSettings();
  }

  Future<void> setExportSuggestions(bool newValue) async {
    final settingsRepo = await ref.read(settingsRepositoryProvider.future);
    await settingsRepo.setExportSuggestions(newValue);

    final previous = state.value!;
    state = AsyncData(previous.copyWith(exportSuggestions: newValue));
  }

  Future<void> setExportWarnings(bool newValue) async {
    final settingsRepo = await ref.read(settingsRepositoryProvider.future);
    await settingsRepo.setExportWarnings(newValue);

    final previous = state.value!;
    state = AsyncData(previous.copyWith(exportWarnings: newValue));
  }

  Future<void> setTheme(ThemeMode newValue) async {
    final settingsRepo = await ref.read(settingsRepositoryProvider.future);
    await settingsRepo.setTheme(newValue);

    final previous = state.value!;
    state = AsyncData(previous.copyWith(theme: newValue));
  }

  Future<void> setSortingOption(SortingOption newValue) async {
    final settingsRepo = await ref.read(settingsRepositoryProvider.future);
    await settingsRepo.setSortingOption(newValue);

    final previous = state.value!;
    state = AsyncData(previous.copyWith(sortingOption: newValue));
  }
}
