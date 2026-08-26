import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  final SharedPreferences _preferences;

  SharedPrefService(this._preferences);

  // ── Save Data ─────────────────────────────────────────────────────────────
  Future<bool> setData(String key, dynamic value) async {
    if (value is String) return await _preferences.setString(key, value);
    if (value is int) return await _preferences.setInt(key, value);
    if (value is bool) return await _preferences.setBool(key, value);
    if (value is double) return await _preferences.setDouble(key, value);
    return false;
  }

  // ── Get Data ─────────────────────────────────────────────────────────────
  dynamic getData(String key) {
    return _preferences.get(key);
  }

  String getString(String key) {
    return _preferences.getString(key) ?? '';
  }

  bool getBool(String key) {
    return _preferences.getBool(key) ?? false;
  }

  // ── Clear / Remove ───────────────────────────────────────────────────────
  Future<bool> removeData(String key) async {
    return await _preferences.remove(key);
  }

  Future<bool> clearAll() async {
    return await _preferences.clear();
  }
}