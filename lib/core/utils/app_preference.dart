import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  AppPreference(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  Future<bool> isContainsKey(String key) async {
    return sharedPreferences.containsKey(key);
  }

  //! GETTER
  Future<String> getString(String key) async {
    return sharedPreferences.getString(key) ?? '';
  }

  Future<bool> getBool(String key) async {
    return sharedPreferences.getBool(key) ?? false;
  }

  Future<int> getInt(String key) async {
    return sharedPreferences.getInt(key) ?? 0;
  }

  Future<double> getDouble(String key) async {
    return sharedPreferences.getDouble(key) ?? 0.0;
  }

  Future<List<String>> getStringList(String key) async {
    return sharedPreferences.getStringList(key) ?? [];
  }

  Future<Set<String>> getKeys() async {
    return sharedPreferences.getKeys();
  }

  //! SETTER
  Future<bool> setString(String key, String value) async {
    return sharedPreferences.setString(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return sharedPreferences.setBool(key, value);
  }

  Future<bool> setInt(String key, int value) async {
    return sharedPreferences.setInt(key, value);
  }

  Future<bool> setDouble(String key, double value) async {
    return sharedPreferences.setDouble(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return sharedPreferences.setStringList(key, value);
  }

  //! REMOVE
  Future<bool> remove(String key) async {
    return sharedPreferences.remove(key);
  }

  Future<bool> clear() async {
    return sharedPreferences.clear();
  }

  Future<void> reload() async {
    return sharedPreferences.reload();
  }
}
