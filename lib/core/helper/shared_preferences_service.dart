import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';



/// Service class to handle all SharedPreferences operations
class SharedPreferencesService {
  final SharedPreferences _preferences;

  // Keys for storing data
  static const String _kUserToken = 'user_token';
  static const String _kUserId = 'user_id';
  static const String _kUserName = 'user_name';
  static const String _kIsFirstLaunch = 'is_first_launch';
  static const String _kThemeMode = 'theme_mode';
  static const String _kLanguageCode = 'language_code';

  // Constructor with dependency injection
  SharedPreferencesService(this._preferences);

  // User related methods
  Future<bool> setUserToken(String token) async {
    return await _preferences.setString(_kUserToken, token);
  }

  String? getUserToken() {
    return _preferences.getString(_kUserToken);
  }

  Future<bool> setUserId(int userId) async {
    return await _preferences.setInt(_kUserId, userId);
  }

  int? getUserId() {
    return _preferences.getInt(_kUserId);
  }

  Future<bool> setUserName(String name) async {
    return await _preferences.setString(_kUserName, name);
  }

  String? getUserName() {
    return _preferences.getString(_kUserName);
  }

  // App state methods
  Future<bool> setIsFirstLaunch(bool isFirst) async {
    return await _preferences.setBool(_kIsFirstLaunch, isFirst);
  }

  bool getIsFirstLaunch() {
    return _preferences.getBool(_kIsFirstLaunch) ?? true;
  }

  Future<bool> setThemeMode(String themeMode) async {
    return await _preferences.setString(_kThemeMode, themeMode);
  }

  String getThemeMode() {
    return _preferences.getString(_kThemeMode) ?? 'light';
  }

  Future<bool> setLanguageCode(String languageCode) async {
    return await _preferences.setString(_kLanguageCode, languageCode);
  }

  String getLanguageCode() {
    return _preferences.getString(_kLanguageCode) ?? 'en';
  }

  // Clear all data
  Future<bool> clearAll() async {
    return await _preferences.clear();
  }

  // Clear specific user data
  Future<void> clearUserData() async {
    await _preferences.remove(_kUserToken);
    await _preferences.remove(_kUserId);
    await _preferences.remove(_kUserName);
  }
}
