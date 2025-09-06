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

      if (response.data['user'] != null) {
        _currentUser = response.data['user'];
        await NetworkHelper.saveUserData(response.data['user']);
      }
    }

    return response;
  }

  static Future<ApiResponse> logout() async {
    final response = await ApiClient.post(ApiUrls.logout, {});

    await NetworkHelper.clearAuthData();
    ApiClient.clearToken();
    _currentUser = null;

    return response;
  }

  static Future<ApiResponse> getUser() async {
    final response = await ApiClient.get(ApiUrls.getUser);

    if (response.success && response.data != null) {
      if (response.data['user'] != null) {
        _currentUser = response.data['user'];
        await NetworkHelper.saveUserData(response.data['user']);
      }
    }

    return response;
  }

  static Future<ApiResponse> deleteAccount() async {
    final response = await ApiClient.delete(ApiUrls.deleteAccount);

    if (response.success) {
      await clearUserData();
    }

    return response;
  }

  static Future<bool> isLoggedIn() async {
    final token = await NetworkHelper.getToken();
    if (token != null) {
      ApiClient.setToken(token);

      // تحميل بيانات المستخدم إذا لم تكن محملة
      if (_currentUser == null) {
        _currentUser = await NetworkHelper.getUserData();
      }

      // التحقق من صحة التوكن
      if (_currentUser == null) {
        final userResponse = await getUser();
        return userResponse.success;
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

  // Helper getters
  static String? get userName {
    return _currentUser?['name'];
  }

  static String? get userEmail {
    return _currentUser?['email'];
  }

  static String? get userPhone {
    return _currentUser?['phone'];
  }

  static String? get userType {
    return _currentUser?['user_type'];
  }

  static int? get userId {
    final id = _currentUser?['id'];
    return id is int ? id : (id != null ? int.tryParse(id.toString()) : null);
  }

  static bool get isProvider {
    return userType == 'provider';
  }

  static bool get isCustomer {
    return userType == 'customer';
  }

  static bool get isEmailVerified {
    return _currentUser?['email_verified_at'] != null;
  }

  static DateTime? get emailVerifiedAt {
    final dateStr = _currentUser?['email_verified_at'];
    return dateStr != null ? DateTime.tryParse(dateStr) : null;
  }

  static DateTime? get createdAt {
    final dateStr = _currentUser?['created_at'];
    return dateStr != null ? DateTime.tryParse(dateStr) : null;
  }

  static Map<String, dynamic>? get providerProfile {
    return _currentUser?['provider_profile'];
  }

  static bool get hasProviderProfile {
    return providerProfile != null;
  }

  // Helper methods
  static Future<void> updateUserData(Map<String, dynamic> userData) async {
    _currentUser = userData;
    await NetworkHelper.saveUserData(userData);
  }

  static Future<void> clearUserData() async {
    await NetworkHelper.clearAuthData();
    ApiClient.clearToken();
    _currentUser = null;
  }
}