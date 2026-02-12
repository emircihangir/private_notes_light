import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_data.freezed.dart';
part 'settings_data.g.dart';

@freezed
abstract class SettingsData with _$SettingsData {
  factory SettingsData({
    required bool exportSuggestions,
    required bool exportWarnings,
    required ThemeMode theme,
  }) = _SettingsData;

  SettingsData._();

  factory SettingsData.fromJson(Map<String, Object?> json) => _$SettingsDataFromJson(json);

  static const propertyNames = (
    exportSuggestions: 'exportSuggestions',
    exportWarnings: 'exportWarnings',
    theme: 'theme',
  );
}
