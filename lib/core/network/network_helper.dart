// lib/core/network/network_helper.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NetworkHelper {

  // ====================
  // Auth Methods
  // ====================

  /// حفظ التوكن
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    print('Token saved successfully');
  }

  /// جلب التوكن
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null) {
      print('Token found: ${token.substring(0, 10)}...');
    }
    return token;
  }

  /// حذف التوكن
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    print('Token removed');
  }

  /// التحقق من وجود التوكن
  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null;
  }

  /// حفظ بيانات المستخدم
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = json.encode(userData);
    await prefs.setString('user_data', userJson);
    print('User data saved: ${userData['name'] ?? 'Unknown'}');
  }

  /// جلب بيانات المستخدم
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user_data');

    if (userJson != null) {
      try {
        final userData = json.decode(userJson) as Map<String, dynamic>;
        return userData;
      } catch (e) {
        print('Error parsing user data: $e');
        return null;
      }
    }
    return null;
  }

  /// حذف بيانات المستخدم
  static Future<void> removeUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    print('User data removed');
  }

  // ====================
  // Basic Storage
  // ====================

  /// حفظ نص
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  /// جلب نص
  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// حفظ bool
  static Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  /// جلب bool
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }

  // ====================
  // App Settings
  // ====================

  /// حفظ أول فتح للتطبيق
  static Future<void> setFirstTime(bool isFirst) async {
    await saveBool('is_first_time', isFirst);
  }

  /// التحقق من أول فتح
  static Future<bool> isFirstTime() async {
    return await getBool('is_first_time', defaultValue: true);
  }

  /// حفظ اللغة
  static Future<void> saveLanguage(String languageCode) async {
    await saveString('app_language', languageCode);
  }

  /// جلب اللغة
  static Future<String> getLanguage() async {
    return await getString('app_language') ?? 'ar';
  }

  // ====================
  // Clear Methods
  // ====================

  /// مسح بيانات تسجيل الدخول فقط
  static Future<void> clearAuthData() async {
    await removeToken();
    await removeUserData();
    print('Auth data cleared');
  }

  /// مسح جميع البيانات
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('All data cleared');
  }
}