import 'package:flutter/material.dart';
import 'package:private_notes_light/data/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controller.g.dart';

typedef SettingsState = ({bool exportSuggestions, bool exportWarnings, Brightness? brightness});

@riverpod
class SettingsController extends _$SettingsController {
  @override
  Future<SettingsState> build() async {
    final settingsRepo = await ref.watch(settingsRepositoryProvider.future);

    final settingsPrefs = settingsRepo.getSettings();
    Brightness? brightnessValue;

    if (settingsPrefs.brightness == 'light') {
      brightnessValue = Brightness.light;
    } else if (settingsPrefs.brightness == 'dark') {
      brightnessValue = Brightness.dark;
    }

    return (
      exportSuggestions: settingsPrefs.exportSuggestions,
      exportWarnings: settingsPrefs.exportWarnings,
      brightness: brightnessValue,
    );
  }

  Future<void> setExportSuggestions(bool newValue) async {
    final settingsRepo = await ref.watch(settingsRepositoryProvider.future);
    await settingsRepo.setExportSuggestions(newValue);

    final previous = state.value!;
    state = AsyncData((
      exportSuggestions: newValue,
      exportWarnings: previous.exportWarnings,
      brightness: previous.brightness,
    ));
  }

  Future<void> setExportWarnings(bool newValue) async {
    final settingsRepo = await ref.watch(settingsRepositoryProvider.future);
    await settingsRepo.setExportWarnings(newValue);

    final previous = state.value!;
    state = AsyncData((
      exportSuggestions: previous.exportSuggestions,
      exportWarnings: newValue,
      brightness: previous.brightness,
    ));
  }

  Future<void> setBrightness(Brightness? newBrightness) async {
    final settingsRepo = await ref.watch(settingsRepositoryProvider.future);

    String? newBrightnessValue;
    if (newBrightness == Brightness.light || newBrightness == Brightness.dark) {
      newBrightnessValue = newBrightness!.name;
    }

    await settingsRepo.setBrightness(newBrightnessValue);

    final previous = state.value!;
    state = AsyncData((
      exportSuggestions: previous.exportSuggestions,
      exportWarnings: previous.exportWarnings,
      brightness: newBrightness,
    ));
  }
}
