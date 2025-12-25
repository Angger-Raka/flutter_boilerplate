import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/app.dart';
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

  await setupLocator();
  runApp(const App());
}

Future<void> runnerApp() async {
  runApp(const App());
}
