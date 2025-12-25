import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  Future<void> init() async {
    await sharedPreferences.reload();
  }

  Future<void> saveData(String key, dynamic value) async {
    await sharedPreferences.setString(key, jsonEncode(value));
  }

  Future<dynamic> getData(String key) async {
    final jsonString = sharedPreferences.getString(key);
    if (jsonString == null) return null;
    return jsonDecode(jsonString);
  }

  Future<void> removeData(String key) async {
    await sharedPreferences.remove(key);
  }

  Future<void> updateData(String key, dynamic value) async {
    await sharedPreferences.setString(key, jsonEncode(value));
  }

  Future<void> clearAll() async {
    await sharedPreferences.clear();
  }
}
