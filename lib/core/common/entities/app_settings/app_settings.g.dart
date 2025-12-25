// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
      appLanguage: json['AppLanguage'] == null
          ? null
          : AppLanguage.fromJson(json['AppLanguage'] as Map<String, dynamic>),
      appThemeMode:
          $enumDecodeNullable(_$ThemeModeEnumMap, json['AppThemeMode']),
      envType: $enumDecodeNullable(_$EnvTypeEnumMap, json['EnvType']),
    );

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'AppLanguage': instance.appLanguage,
      'AppThemeMode': _$ThemeModeEnumMap[instance.appThemeMode],
      'EnvType': _$EnvTypeEnumMap[instance.envType],
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

const _$EnvTypeEnumMap = {
  EnvType.dev: 'dev',
  EnvType.staging: 'staging',
  EnvType.prod: 'prod',
};
