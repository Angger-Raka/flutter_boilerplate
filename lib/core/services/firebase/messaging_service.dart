import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('🔔 Background message: ${message.messageId}');
}

/// Messaging service for push notifications
class MessagingService {
  MessagingService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static String? _fcmToken;

  /// Get current FCM token
  static String? get fcmToken => _fcmToken;

  /// Initialize messaging service
  static Future<void> initialize({
    Function(RemoteMessage)? onMessageOpenedApp,
    Function(String?)? onTokenRefresh,
  }) async {
    try {
      // Request permission
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint('🔔 Notification permission: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Get FCM token
        _fcmToken = await _messaging.getToken();
        debugPrint('🔔 FCM Token: $_fcmToken');

        // Listen for token refresh
        _messaging.onTokenRefresh.listen((token) {
          _fcmToken = token;
          debugPrint('🔔 FCM Token refreshed: $token');
          onTokenRefresh?.call(token);
        });

        // Setup local notifications
        await _setupLocalNotifications();

        // Handle foreground messages
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

        // Handle background messages
        FirebaseMessaging.onBackgroundMessage(
            firebaseMessagingBackgroundHandler);

        // Handle notification tap when app is in background
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          debugPrint('🔔 Message opened app: ${message.messageId}');
          onMessageOpenedApp?.call(message);
        });

        // Check if app was opened from notification
        final initialMessage = await _messaging.getInitialMessage();
        if (initialMessage != null) {
          debugPrint('🔔 Initial message: ${initialMessage.messageId}');
          onMessageOpenedApp?.call(initialMessage);
        }
      }
    } catch (e) {
      debugPrint('⚠️ Messaging initialization error: $e');
    }
  }

  /// Setup local notifications for foreground display
  static Future<void> _setupLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(settings: settings);

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Handle foreground message
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('🔔 Foreground message: ${message.messageId}');

    final notification = message.notification;
    if (notification != null) {
      await showLocalNotification(
        title: notification.title ?? '',
        body: notification.body ?? '',
        payload: jsonEncode(message.data),
      );
    }
  }

  /// Show local notification
  static Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  /// Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    debugPrint('🔔 Subscribed to topic: $topic');
  }

  /// Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('🔔 Unsubscribed from topic: $topic');
  }
}
