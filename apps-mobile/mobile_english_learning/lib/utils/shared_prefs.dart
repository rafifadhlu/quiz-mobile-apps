import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool?> readPrefBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> saveStr(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> readPrefStr(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  
  static Future<List<String>?> readPrefStrList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  static Future<void> removePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final freshOpenValue = prefs.getBool('is_freshOpen') ?? true;
    await prefs.clear();
    await prefs.setBool('is_freshOpen', freshOpenValue);
  }

  static Future<void> setNewToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.setString('access_token', token);
  }

  static Future<void> saveUserSession({
    required String accessToken,
    required String refreshToken,
    required int userId,
    required String username,
    required String email,
    required String firstname,
    required String lastname,
    required List<String> groups,
  }) async {
        final prefs = await SharedPreferences.getInstance();

        // batch all writes with Futures
        await Future.wait([
          prefs.setString('access_token', accessToken),
          prefs.setString('refresh_token', refreshToken),
          prefs.setString('user_id', userId.toString()),
          prefs.setString('user_username', username),
          prefs.setString('user_email', email),
          prefs.setString('user_firstname', firstname),
          prefs.setString('user_lastname', lastname),
          prefs.setStringList('user_groups', groups),
        ]);
  }
}