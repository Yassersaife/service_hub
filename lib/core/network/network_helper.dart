// lib/core/network/network_helper.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NetworkHelper {

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

  /// حفظ قائمة
  static Future<void> saveStringList(String key, List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, list);
  }

  /// جلب قائمة
  static Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
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

  /// حفظ اللغة
  static Future<void> saveLanguage(String languageCode) async {
    await saveString('app_language', languageCode);
  }

  /// جلب اللغة
  static Future<String> getLanguage() async {
    return await getString('app_language') ?? 'ar';
  }

  /// حفظ أول فتح للتطبيق
  static Future<void> setFirstTime(bool isFirst) async {
    await saveBool('is_first_time', isFirst);
  }

  /// التحقق من أول فتح
  static Future<bool> isFirstTime() async {
    return await getBool('is_first_time', defaultValue: true);
  }

  // ====================
  // Clear Methods
  // ====================

  /// مسح جميع البيانات
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('All data cleared');
  }

  /// مسح بيانات تسجيل الدخول فقط
  static Future<void> clearAuthData() async {
    await removeToken();
    await removeUserData();
    print('Auth data cleared');
  }

  // ====================
  // Cache Management
  // ====================

  /// حفظ كاش مع تاريخ انتهاء
  static Future<void> saveCache(String key, String data, {Duration? expiry}) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiry': expiry?.inMilliseconds,
    };

    await prefs.setString('cache_$key', json.encode(cacheData));
  }

  /// جلب من الكاش مع التحقق من الصلاحية
  static Future<String?> getCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheJson = prefs.getString('cache_$key');

    if (cacheJson != null) {
      try {
        final cacheData = json.decode(cacheJson) as Map<String, dynamic>;
        final timestamp = cacheData['timestamp'] as int;
        final expiry = cacheData['expiry'] as int?;

        // التحقق من انتهاء الصلاحية
        if (expiry != null) {
          final expiryTime = timestamp + expiry;
          if (DateTime.now().millisecondsSinceEpoch > expiryTime) {
            // انتهت الصلاحية، احذف الكاش
            await prefs.remove('cache_$key');
            return null;
          }
        }

        return cacheData['data'] as String;
      } catch (e) {
        print('Error reading cache for $key: $e');
        return null;
      }
    }
    return null;
  }

  /// مسح الكاش
  static Future<void> clearCache(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cache_$key');
  }

  /// مسح جميع الكاش
  static Future<void> clearAllCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    for (String key in keys) {
      if (key.startsWith('cache_')) {
        await prefs.remove(key);
      }
    }
    print('All cache cleared');
  }

  // ====================
  // Debug Methods
  // ====================

  static Future<void> printAllKeys() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    print('Saved keys (${keys.length}): ${keys.toList()}');
  }
}