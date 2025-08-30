import 'package:service_hub/core/network/api_client.dart';
import 'package:service_hub/features/service_provider/models/provider_profile.dart';
import 'package:service_hub/features/auth/services/auth_service.dart';

class ProviderService {
  static final ProviderService _instance = ProviderService._internal();
  factory ProviderService() => _instance;
  ProviderService._internal();

  Future<bool> saveProfile(ProviderProfile profile) async {
    try {
      print('حفظ الملف الشخصي لـ: ${profile.userId}');

      // تحقق إذا كان يوجد profile مسبقاً
      final existingProfile = await getMyProfile();

      if (existingProfile != null) {
        print('تحديث الملف الشخصي الموجود');
        return await updateProfile(profile);
      } else {
        print('إنشاء ملف شخصي جديد');
        return await createProfile(profile);
      }
    } catch (e) {
      print('خطأ في saveProfile: $e');
      return false;
    }
  }

  /// إنشاء ملف شخصي جديد
  Future<bool> createProfile(ProviderProfile profile) async {
    try {
      final response = await ApiClient.post('/providers', profile.toJson());

      print('نتيجة الإنشاء: ${response.success}');
      if (!response.success) {
        print('خطأ في الإنشاء: ${response.message}');
      }

      return response.success;
    } catch (e) {
      print('خطأ في createProfile: $e');
      return false;
    }
  }

  /// تحديث الملف الشخصي
  Future<bool> updateProfile(ProviderProfile profile) async {
    try {
      // حسب الـ Laravel routes، استخدم endpoint بدون ID
      final response = await ApiClient.put('/providers/1', profile.toJson());

      print('نتيجة التحديث: ${response.success}');
      if (!response.success) {
        print('خطأ في التحديث: ${response.message}');
      }

      return response.success;
    } catch (e) {
      print('خطأ في updateProfile: $e');
      return false;
    }
  }

  /// جلب ملفي الشخصي
  Future<ProviderProfile?> getMyProfile() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) {
        print('لا يوجد مستخدم مسجل دخول');
        return null;
      }

      print('جلب الملف الشخصي للمستخدم: ${user['id']}');

      // الـ endpoint الصحيح من routes
      final response = await ApiClient.get('/providers/my/profile');

      if (response.success && response.data != null) {
        print('البيانات المستلمة: ${response.data}');
        print('نوع البيانات: ${response.data.runtimeType}');

        // استخدام fromJson اللي يتعامل مع List و Map
        final profile = ProviderProfile.fromJson(response.data);

        if (profile.userId.isNotEmpty) {
          print('تم جلب الملف الشخصي: ${profile.name}');
          return profile;
        }
      }

      print('لا يوجد ملف شخصي');
      return null;
    } catch (e) {
      print('خطأ في getMyProfile: $e');
      return null;
    }
  }

  Future<ProviderProfile?> getProfile(String userId) async {
    try {
      print('جلب الملف الشخصي للمستخدم: $userId');

      final userIdString = userId.toString();
      final response = await ApiClient.get('/providers/$userIdString');

      if (response.success && response.data != null) {
        print('البيانات المستلمة: ${response.data}');

        // استخدام fromJson اللي يتعامل مع List و Map
        final profile = ProviderProfile.fromJson(response.data);

        if (profile.userId.isNotEmpty) {
          print('تم جلب الملف الشخصي: ${profile.name}');
          return profile;
        }
      }

      print('لا يوجد ملف شخصي للمستخدم: $userIdString');
      return null;
    } catch (e) {
      print('خطأ في getProfile: $e');
      return null;
    }
  }

  Future<List<ProviderProfile>> getAllProviders() async {
    try {
      final response = await ApiClient.get('/providers');

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        final List<ProviderProfile> profiles = [];

        for (final data in providersData) {
          try {
            final profile = ProviderProfile.fromJson(data);
            if (profile.isProfileComplete) {
              profiles.add(profile);
            }
          } catch (e) {
            print('تجاهل ملف شخصي: $e');
            continue;
          }
        }

        return profiles;
      }

      return [];
    } catch (e) {
      print('خطأ في getAllProviders: $e');
      return [];
    }
  }

  Future<List<ProviderProfile>> searchProviders({
    String? query,
    String? serviceType,
    String? city,
  }) async {
    try {
      String searchUrl = '/providers/search';
      final params = <String>[];

      if (query != null && query.isNotEmpty) {
        params.add('q=${Uri.encodeComponent(query)}');
      }
      if (serviceType != null && serviceType.isNotEmpty) {
        params.add('service_type=${Uri.encodeComponent(serviceType)}');
      }
      if (city != null && city.isNotEmpty) {
        params.add('city=${Uri.encodeComponent(city)}');
      }

      if (params.isNotEmpty) {
        searchUrl += '?${params.join('&')}';
      }

      final response = await ApiClient.get(searchUrl);

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        final List<ProviderProfile> profiles = [];

        for (final data in providersData) {
          try {
            final profile = ProviderProfile.fromJson(data);
            profiles.add(profile);
          } catch (e) {
            print('تجاهل نتيجة بحث: $e');
            continue;
          }
        }

        return profiles;
      }

      return [];
    } catch (e) {
      print('خطأ في البحث: $e');
      return [];
    }
  }

  /// حذف الملف الشخصي
  Future<bool> deleteProfile(String userId) async {
    try {
      final userIdString = userId.toString();
      final response = await ApiClient.delete('/providers/profile/$userIdString');
      return response.success;
    } catch (e) {
      print('خطأ في deleteProfile: $e');
      return false;
    }
  }

  /// تحديث حالة التوثيق
  Future<bool> updateVerificationStatus(String providerId, bool isVerified) async {
    try {
      final providerIdString = providerId.toString();
      final response = await ApiClient.put('/providers/$providerIdString/verify', {
        'is_verified': isVerified,
      });
      return response.success;
    } catch (e) {
      print('خطأ في updateVerificationStatus: $e');
      return false;
    }
  }

  Future<List<ProviderProfile>> getTopRatedProviders({int limit = 10}) async {
    try {
      final response = await ApiClient.get('/providers/featured');

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        final List<ProviderProfile> profiles = [];

        for (final data in providersData) {
          try {
            final profile = ProviderProfile.fromJson(data);
            if (profile.isProfileComplete) {
              profiles.add(profile);
            }
          } catch (e) {
            print('تجاهل مقدم خدمة مميز: $e');
            continue;
          }
        }

        profiles.sort((a, b) => b.rating.compareTo(a.rating));
        return profiles.take(limit).toList();
      }

      return [];
    } catch (e) {
      print('خطأ في getTopRatedProviders: $e');
      return [];
    }
  }

  Future<List<ProviderProfile>> getVerifiedProviders() async {
    try {
      final response = await ApiClient.get('/providers/verified');

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        final List<ProviderProfile> profiles = [];

        for (final data in providersData) {
          try {
            final profile = ProviderProfile.fromJson(data);
            if (profile.isVerified && profile.isProfileComplete) {
              profiles.add(profile);
            }
          } catch (e) {
            print('تجاهل مقدم خدمة موثق: $e');
            continue;
          }
        }

        return profiles;
      }

      return [];
    } catch (e) {
      print('خطأ في getVerifiedProviders: $e');
      return [];
    }
  }

  Future<bool> hasProfile() async {
    try {
      final profile = await getMyProfile();
      return profile != null;
    } catch (e) {
      print('خطأ في hasProfile: $e');
      return false;
    }
  }

  Future<bool> isProfileComplete() async {
    try {
      final profile = await getMyProfile();
      return profile?.isProfileComplete ?? false;
    } catch (e) {
      print('خطأ في isProfileComplete: $e');
      return false;
    }
  }


  Future<bool> deleteAccount() async {
    try {
      final response = await ApiClient.delete('auth/account/delete');
      return response.success;
    } catch (e) {
      print('خطأ في حذف الحساب: $e');
      return false;
    }
  }
  }