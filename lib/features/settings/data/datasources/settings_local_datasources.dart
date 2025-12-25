import 'package:flutter_boilerplate/core/core.dart';

abstract class SettingsLocalDataSources {
  Future<bool> init();
  Future<AppSettings> getSettings();
  Future<bool> saveSettings(AppSettings settings);
  Future<bool> updateSettings(AppSettings settings);
  Future<bool> clearSettings();
}

class SettingsLocalDataSourcesImpl implements SettingsLocalDataSources {
  SettingsLocalDataSourcesImpl({required this.localStorageService});

  final LocalStorageService localStorageService;

  static const String _settingsKey = AppPreferenceKeys.settings;

  @override
  Future<bool> init() async {
    await localStorageService.init();
    return true;
  }

  @override
  Future<AppSettings> getSettings() async {
    final data = await localStorageService.getData(_settingsKey);
    return AppSettings.fromJson(data as Map<String, dynamic>?);
  }

  @override
  Future<bool> saveSettings(AppSettings settings) async {
    await localStorageService.saveData(_settingsKey, settings.toJson());
    return true;
  }

  @override
  Future<bool> updateSettings(AppSettings settings) async {
    await localStorageService.updateData(_settingsKey, settings.toJson());
    return true;
  }

  @override
  Future<bool> clearSettings() async {
    await localStorageService.removeData(_settingsKey);
    return true;
  }
}
