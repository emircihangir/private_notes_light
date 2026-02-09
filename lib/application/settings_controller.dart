import 'package:flutter/material.dart';
import 'package:private_notes_light/data/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controller.g.dart';

typedef SettingsState = ({bool autoExport, Brightness? brightness});

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

    return (autoExport: settingsPrefs.autoExport, brightness: brightnessValue);
  }

  Future<void> setAutoExport(bool newValue) async {
    final settingsRepo = await ref.watch(settingsRepositoryProvider.future);
    await settingsRepo.setAutoExport(newValue);

    final previous = state.value!;
    state = AsyncData((autoExport: newValue, brightness: previous.brightness));
  }

  Future<void> setBrightness(Brightness? newBrightness) async {
    final settingsRepo = await ref.watch(settingsRepositoryProvider.future);

    String? newBrightnessValue;
    if (newBrightness == Brightness.light || newBrightness == Brightness.dark) {
      newBrightnessValue = newBrightness!.name;
    }

    await settingsRepo.setBrightness(newBrightnessValue);

    final previous = state.value!;
    state = AsyncData((autoExport: previous.autoExport, brightness: newBrightness));
  }
}
