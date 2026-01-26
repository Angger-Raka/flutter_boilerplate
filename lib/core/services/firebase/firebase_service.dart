import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Firebase initialization service
///
/// IMPORTANT: Before using Firebase, run:
/// ```bash
/// dart pub global activate flutterfire_cli
/// flutterfire configure
/// ```
/// This will generate `lib/firebase_options.dart`
class FirebaseService {
  FirebaseService._();

  static bool _initialized = false;

  /// Check if Firebase is initialized
  static bool get isInitialized => _initialized;

  /// Initialize Firebase
  /// Call this in main() before runApp()
  ///
  /// If Firebase is not configured, this will gracefully skip initialization
  /// and the app will run without Firebase features.
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Try to initialize Firebase
      // This will fail if firebase_options.dart doesn't exist or
      // google-services.json / GoogleService-Info.plist is not configured
      await Firebase.initializeApp();
      _initialized = true;

      // Setup Crashlytics error handling
      if (!kDebugMode) {
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }

      debugPrint('🔥 Firebase initialized successfully');
    } catch (e) {
      _initialized = false;
      debugPrint('⚠️ Firebase not configured - running without Firebase');
      debugPrint('💡 To enable Firebase, run: flutterfire configure');
      // App will continue running without Firebase
    }
  }
}
