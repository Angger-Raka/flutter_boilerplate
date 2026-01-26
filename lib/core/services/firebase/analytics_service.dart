import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Analytics service for tracking user behavior and events
class AnalyticsService {
  AnalyticsService._();

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Get analytics observer for navigation tracking
  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Log a custom event
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
      debugPrint('📊 Analytics event: $name');
    } catch (e) {
      debugPrint('⚠️ Analytics error: $e');
    }
  }

  /// Log screen view
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );
      debugPrint('📊 Screen view: $screenName');
    } catch (e) {
      debugPrint('⚠️ Analytics error: $e');
    }
  }

  /// Set user ID for analytics
  static Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
      debugPrint('📊 User ID set: $userId');
    } catch (e) {
      debugPrint('⚠️ Analytics error: $e');
    }
  }

  /// Set user property
  static Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      debugPrint('📊 User property: $name = $value');
    } catch (e) {
      debugPrint('⚠️ Analytics error: $e');
    }
  }

  /// Log login event
  static Future<void> logLogin({String? loginMethod}) async {
    await logEvent(
      name: 'login',
      parameters: loginMethod != null ? {'method': loginMethod} : null,
    );
  }

  /// Log sign up event
  static Future<void> logSignUp({String? signUpMethod}) async {
    await logEvent(
      name: 'sign_up',
      parameters: signUpMethod != null ? {'method': signUpMethod} : null,
    );
  }

  /// Log purchase event
  static Future<void> logPurchase({
    required double value,
    required String currency,
    String? transactionId,
  }) async {
    await _analytics.logPurchase(
      value: value,
      currency: currency,
      transactionId: transactionId,
    );
  }
}
