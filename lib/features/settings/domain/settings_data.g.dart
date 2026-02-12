// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsData _$SettingsDataFromJson(Map<String, dynamic> json) =>
    _SettingsData(
      exportSuggestions: json['exportSuggestions'] as bool,
      exportWarnings: json['exportWarnings'] as bool,
      theme: $enumDecode(_$ThemeModeEnumMap, json['theme']),
    );

Map<String, dynamic> _$SettingsDataToJson(_SettingsData instance) =>
    <String, dynamic>{
      'exportSuggestions': instance.exportSuggestions,
      'exportWarnings': instance.exportWarnings,
      'theme': _$ThemeModeEnumMap[instance.theme]!,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
