import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Service for checking network connectivity
class NetworkService {
  NetworkService._();

  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<List<ConnectivityResult>>? _subscription;

  /// Check if device has internet connection
  static Future<bool> hasConnection() async {
    final results = await _connectivity.checkConnectivity();
    return _isConnected(results);
  }

  /// Get current connectivity status
  static Future<ConnectivityResult> getConnectivityStatus() async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty ? results.first : ConnectivityResult.none;
  }

  /// Stream of connectivity changes
  static Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_isConnected);
  }

  /// Listen to connectivity changes
  static void startListening({
    required Function(bool isConnected) onConnectionChanged,
  }) {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final isConnected = _isConnected(results);
      debugPrint('🌐 Network: ${isConnected ? 'Connected' : 'Disconnected'}');
      onConnectionChanged(isConnected);
    });
  }

  /// Stop listening to connectivity changes
  static void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Check if connected based on results
  static bool _isConnected(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((result) =>
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet);
  }

  /// Get connectivity type as string
  static String getConnectivityTypeString(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
        return 'No Connection';
    }
  }
}
