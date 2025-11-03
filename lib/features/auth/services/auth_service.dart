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
    required String userType,
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

  static Future<ApiResponse> forgotPassword({
    required String email,
  }) async {
    final response = await ApiClient.post(ApiUrls.forgotPassword, {
      'email': email,
    });

    return response;
  }

  static Future<ApiResponse> verifyResetToken({
    required String email,
    required String token,
  }) async {
    final response = await ApiClient.post(ApiUrls.verifyResetToken, {
      'email': email,
      'otp': token,
    });

    return response;
  }

  static Future<ApiResponse> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await ApiClient.post(ApiUrls.resetPassword, {
      'email': email,
      'otp': token,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });

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

      if (_currentUser == null) {
        _currentUser = await NetworkHelper.getUserData();
      }

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

  static String? get userName => _currentUser?['name'];

  static String? get userEmail => _currentUser?['email'];

  static String? get userPhone => _currentUser?['phone'];

  static String? get userType => _currentUser?['user_type'];

  static int? get userId {
    final id = _currentUser?['id'];
    return id is int ? id : (id != null ? int.tryParse(id.toString()) : null);
  }

  static bool get isProvider => userType == 'provider';

  static bool get isCustomer => userType == 'customer';

  static bool get isEmailVerified => _currentUser?['email_verified_at'] != null;

  static DateTime? get emailVerifiedAt {
    final dateStr = _currentUser?['email_verified_at'];
    return dateStr != null ? DateTime.tryParse(dateStr) : null;
  }

  static DateTime? get createdAt {
    final dateStr = _currentUser?['created_at'];
    return dateStr != null ? DateTime.tryParse(dateStr) : null;
  }

  static Map<String, dynamic>? get providerProfile => _currentUser?['provider_profile'];

  static bool get hasProviderProfile => providerProfile != null;

  static Future<void> updateUserData(Map<String, dynamic> userData) async {
    _currentUser = userData;
    await NetworkHelper.saveUserData(userData);
  }

  static Future<void> clearUserData() async {
    await NetworkHelper.clearAuthData();
    ApiClient.clearToken();
    _currentUser = null;
  }

  static Future<String?> getAppPhone() async {
    final response = await ApiClient.get(ApiUrls.settings);

    if (response.success && response.data != null) {
      final dataList = response.data as List<dynamic>;
      final appPhoneItem = dataList.firstWhere(
            (item) => item['key'] == 'app_phone',
        orElse: () => null,
      );
      return appPhoneItem != null ? appPhoneItem['value'] as String? : null;
    }

    return null;
  }

  static Future<String?> getWhatsapp() async {
    final response = await ApiClient.get(ApiUrls.settings);

    if (response.success && response.data != null) {
      final dataList = response.data as List<dynamic>;
      final whatsappItem = dataList.firstWhere(
            (item) => item['key'] == 'whatsapp',
        orElse: () => null,
      );
      return whatsappItem != null ? whatsappItem['value'] as String? : null;
    }

    return null;
  }
}