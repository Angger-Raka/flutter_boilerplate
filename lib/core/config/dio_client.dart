import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/core/core.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class DioClient {
  final Dio dio;
  final AppPreference prefs;
  final GoRouter router;
  late Dio client;

  DioClient({
    required this.dio,
    required this.prefs,
    required this.router,
    EnvType? environment,
  }) {
    client = dio;

    // Set base URL based on environment
    final env = environment ?? EnvironmentConfig.defaultEnv;
    client.options.baseUrl = EnvironmentConfig.getBaseUrl(env);
    client.options.connectTimeout = const Duration(seconds: 60);
    client.options.receiveTimeout = const Duration(seconds: 60);
    client.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add logging interceptor in debug mode
    if (kDebugMode) {
      client.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          logPrint: (object) => debugPrint(object.toString()),
        ),
      );
    }

    // Add retry interceptor
    client.interceptors.add(
      RetryInterceptor(
        dio: dio,
        retries: 3,
        retryDelays: [
          const Duration(seconds: 10),
          const Duration(seconds: 20),
          const Duration(seconds: 30),
        ],
      ),
    );
  }

  /// Update base URL when environment changes
  void updateEnvironment(EnvType env) {
    client.options.baseUrl = EnvironmentConfig.getBaseUrl(env);
    if (kDebugMode) {
      debugPrint('🌍 Environment changed to: ${env.label}');
      debugPrint('🔗 Base URL: ${client.options.baseUrl}');
    }
  }

  /// Set authorization token
  void setAuthToken(String token) {
    client.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Clear authorization token
  void clearAuthToken() {
    client.options.headers.remove('Authorization');
  }
}
