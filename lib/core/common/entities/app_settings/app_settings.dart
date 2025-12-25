import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core.dart';

part 'app_settings.g.dart';

@JsonSerializable()
class AppSettings extends Equatable {
  @JsonKey(name: 'AppLanguage')
  final AppLanguage? appLanguage;
  @JsonKey(name: 'AppThemeMode')
  final ThemeMode? appThemeMode;
  @JsonKey(name: 'EnvType')
  final EnvType? envType;

  const AppSettings({this.appLanguage, this.appThemeMode, this.envType});

  /// Default settings for the app
  factory AppSettings.defaultSettings() {
    return const AppSettings(
      appLanguage: AppLanguage.english,
      appThemeMode: ThemeMode.system,
      envType: EnvType.dev,
    );
  }

  /// Get language with fallback to default
  AppLanguage get language => appLanguage ?? AppLanguage.english;

  /// Get theme mode with fallback to default
  ThemeMode get themeMode => appThemeMode ?? ThemeMode.system;

  /// Get environment with fallback to default
  EnvType get environment => envType ?? EnvType.dev;

  factory AppSettings.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AppSettings.defaultSettings();
    return _$AppSettingsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);

  AppSettings copyWith({
    AppLanguage? appLanguage,
    ThemeMode? appThemeMode,
    EnvType? envType,
  }) {
    return AppSettings(
      appLanguage: appLanguage ?? this.appLanguage,
      appThemeMode: appThemeMode ?? this.appThemeMode,
      envType: envType ?? this.envType,
    );
  }

  @override
  List<Object?> get props => [appLanguage, appThemeMode, envType];
}
