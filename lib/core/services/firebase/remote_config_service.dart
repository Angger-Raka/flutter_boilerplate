import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

/// Remote Config service for feature flags and A/B testing
class RemoteConfigService {
  RemoteConfigService._();

  static final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance;
  static bool _initialized = false;

  /// Initialize Remote Config with default values
  static Future<void> initialize({
    Map<String, dynamic>? defaults,
    Duration fetchTimeout = const Duration(minutes: 1),
    Duration minimumFetchInterval = const Duration(hours: 1),
  }) async {
    if (_initialized) return;

    try {
      // Set config settings
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: fetchTimeout,
        minimumFetchInterval:
            kDebugMode ? const Duration(minutes: 1) : minimumFetchInterval,
      ));

      // Set default values
      if (defaults != null) {
        await _remoteConfig.setDefaults(defaults);
      }

      // Fetch and activate
      await _remoteConfig.fetchAndActivate();

      _initialized = true;
      debugPrint('🎛️ Remote Config initialized');
    } catch (e) {
      debugPrint('⚠️ Remote Config error: $e');
    }
  }

  /// Fetch latest config values
  static Future<bool> fetch() async {
    try {
      final updated = await _remoteConfig.fetchAndActivate();
      debugPrint(
          '🎛️ Remote Config fetched: ${updated ? 'updated' : 'no changes'}');
      return updated;
    } catch (e) {
      debugPrint('⚠️ Remote Config fetch error: $e');
      return false;
    }
  }

  /// Get string value
  static String getString(String key, {String defaultValue = ''}) {
    try {
      return _remoteConfig.getString(key);
    } catch (e) {
      return defaultValue;
    }
  }

  /// Get bool value
  static bool getBool(String key, {bool defaultValue = false}) {
    try {
      return _remoteConfig.getBool(key);
    } catch (e) {
      return defaultValue;
    }
  }

  /// Get int value
  static int getInt(String key, {int defaultValue = 0}) {
    try {
      return _remoteConfig.getInt(key);
    } catch (e) {
      return defaultValue;
    }
  }

  /// Get double value
  static double getDouble(String key, {double defaultValue = 0.0}) {
    try {
      return _remoteConfig.getDouble(key);
    } catch (e) {
      return defaultValue;
    }
  }

  /// Get all values
  static Map<String, RemoteConfigValue> getAll() {
    return _remoteConfig.getAll();
  }

  /// Listen for config updates (real-time)
  static void addOnConfigUpdatedListener(Function() onUpdate) {
    _remoteConfig.onConfigUpdated.listen((event) {
      debugPrint('🎛️ Remote Config updated: ${event.updatedKeys}');
      _remoteConfig.activate().then((_) => onUpdate());
    });
  }
}
