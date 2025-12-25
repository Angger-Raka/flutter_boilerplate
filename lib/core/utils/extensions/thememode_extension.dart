import 'package:flutter/material.dart';

extension ThemeModeExt on ThemeMode {
  String get label {
    switch (this) {
      case ThemeMode.system:
        return "System Default";
      case ThemeMode.light:
        return "Light Mode";
      case ThemeMode.dark:
        return "Dark Mode";
    }
  }

  String get code {
    switch (this) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }

  static ThemeMode fromCode(String code) {
    switch (code) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
