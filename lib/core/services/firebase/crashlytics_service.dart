import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Crashlytics service for crash reporting and error logging
class CrashlyticsService {
  CrashlyticsService._();

  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Enable/disable crash collection
  static Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
    debugPrint(
        '🔥 Crashlytics collection: ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Set user identifier for crash reports
  static Future<void> setUserIdentifier(String identifier) async {
    await _crashlytics.setUserIdentifier(identifier);
    debugPrint('🔥 Crashlytics user: $identifier');
  }

  /// Set custom key-value pair for crash reports
  static Future<void> setCustomKey(String key, Object value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  /// Log a message to Crashlytics
  static void log(String message) {
    _crashlytics.log(message);
    debugPrint('🔥 Crashlytics log: $message');
  }

  /// Record a non-fatal error
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stack,
      reason: reason,
      fatal: fatal,
    );
    debugPrint('🔥 Crashlytics error recorded: $exception');
  }

  /// Record a Flutter error
  static void recordFlutterError(FlutterErrorDetails details) {
    _crashlytics.recordFlutterError(details);
  }

  /// Force a crash (for testing purposes only)
  static void crash() {
    if (kDebugMode) {
      debugPrint('⚠️ Test crash - only works in release mode');
    }
    _crashlytics.crash();
  }
}
