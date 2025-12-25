import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/app.dart';
import 'package:flutter_boilerplate/core/services/firebase/firebase_service.dart';
import 'package:flutter_boilerplate/core/services/firebase/messaging_service.dart';
import 'package:flutter_boilerplate/core/services/firebase/remote_config_service.dart';
import 'package:flutter_boilerplate/locator.dart';

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    HttpOverrides.global = DevHttpOverrides();
  }

  // Initialize Firebase
  await FirebaseService.initialize();

  // Initialize Push Notifications
  await MessagingService.initialize(
    onMessageOpenedApp: (message) {
      debugPrint('🔔 Notification tapped: ${message.data}');
      // Handle deep linking here
    },
  );

  // Initialize Remote Config with defaults
  await RemoteConfigService.initialize(
    defaults: {
      'feature_new_ui': false,
      'maintenance_mode': false,
      'min_app_version': '1.0.0',
    },
  );

  await setupLocator();
  runApp(const App());
}
