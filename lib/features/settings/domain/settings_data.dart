import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:private_notes_light/features/settings/domain/sorting_option.dart';

part 'settings_data.freezed.dart';
part 'settings_data.g.dart';

@freezed
abstract class SettingsData with _$SettingsData {
  factory SettingsData({
    @Default(true) bool exportSuggestions,
    @Default(true) bool exportWarnings,
    @Default(ThemeMode.system) ThemeMode theme,
    @Default(SortingOption.newestFirst) SortingOption sortingOption,
  }) = _SettingsData;

  SettingsData._();

  factory SettingsData.fromJson(Map<String, Object?> json) => _$SettingsDataFromJson(json);

  static const propertyNames = (
    exportSuggestions: 'exportSuggestions',
    exportWarnings: 'exportWarnings',
    theme: 'theme',
    sortingOption: 'sortingOption',
  );
}
