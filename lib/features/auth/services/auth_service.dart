// lib/services/auth_service.dart
import '../../../core/network/api_client.dart';
import '../../../core/network/api_urls.dart';
import '../../../core/network/network_helper.dart';

class AuthService {
  static Map<String, dynamic>? _currentUser;

  static Map<String, dynamic>? get currentUser => _currentUser;

  static Future<ApiResponse> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String userType, // 'customer' أو 'provider'
  }) async {
    final response = await ApiClient.post(ApiUrls.register, {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'user_type': userType,
    });

    if (response.success && response.data != null) {
      final token = response.data['token'];
      if (token != null) {
        await NetworkHelper.saveToken(token);
        ApiClient.setToken(token);
      }

      // احفظ بيانات المستخدم
      if (response.data['user'] != null) {
        _currentUser = response.data['user'];
        await NetworkHelper.saveUserData(response.data['user']);
      }
    }

    return response;
  }

  static Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiClient.post(ApiUrls.login, {
      'email': email,
      'password': password,
    });

    if (response.success && response.data != null) {
      final token = response.data['token'];
      if (token != null) {
        await NetworkHelper.saveToken(token);
        ApiClient.setToken(token);
      }

      // احفظ بيانات المستخدم
      if (response.data['user'] != null) {
        _currentUser = response.data['user'];
        await NetworkHelper.saveUserData(response.data['user']);
      }
    }

    return response;
  }

  static Future<ApiResponse> logout() async {
    final response = await ApiClient.post(ApiUrls.logout, {});

    await NetworkHelper.removeToken();
    await NetworkHelper.removeUserData();
    ApiClient.clearToken();
    _currentUser = null;

    return response;
  }

  static Future<ApiResponse> getUser() async {
    final response = await ApiClient.get(ApiUrls.getUser);

    if (response.success && response.data != null) {
      _currentUser = response.data;
      await NetworkHelper.saveUserData(response.data);
    }

    return response;
  }

  static Future<bool> isLoggedIn() async {
    final token = await NetworkHelper.getToken();
    if (token != null) {
      ApiClient.setToken(token);

      if (_currentUser == null) {
        _currentUser = await NetworkHelper.getUserData();
      }

      return true;
    }
    return false;
  }

  static Future<void> loadSavedData() async {
    final token = await NetworkHelper.getToken();
    if (token != null) {
      ApiClient.setToken(token);
      _currentUser = await NetworkHelper.getUserData();
    }
  }

  static String? get userName {
    return _currentUser?['name'];
  }

  static String? get userEmail {
    return _currentUser?['email'];
  }

  static String? get userType {
    return _currentUser?['user_type'];
  }

  static bool get isProvider {
    return userType == 'provider';
  }

  static bool get isCustomer {
    return userType == 'customer';
  }
}