import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Firebase initialization service
class FirebaseService {
  FirebaseService._();

  static bool _initialized = false;

  /// Check if Firebase is initialized
  static bool get isInitialized => _initialized;

  /// Initialize Firebase
  /// Call this in main() before runApp()
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
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
      debugPrint('⚠️ Firebase initialization failed: $e');
      debugPrint('💡 Run "flutterfire configure" to setup Firebase');
    }
  }
}
