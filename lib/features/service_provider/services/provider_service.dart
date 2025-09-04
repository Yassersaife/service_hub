import 'dart:io';
import 'dart:convert';
import 'package:service_hub/core/network/api_client.dart';
import 'package:service_hub/core/network/api_urls.dart';
import '../models/provider_profile.dart';
import 'package:service_hub/features/auth/services/auth_service.dart';

class ProviderService {
  static final ProviderService _instance = ProviderService._internal();
  factory ProviderService() => _instance;
  ProviderService._internal();

  // ====================
  // CRUD Operations
  // ====================

  Future<bool> saveProfile(ProviderProfile profile) async {
    try {
      print('حفظ الملف الشخصي للمستخدم: ${profile.userId}');

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

  Future<bool> createProfile(ProviderProfile profile) async {
    try {
      final data = {
        'category_id': profile.categoryId,
        'address': profile.address,
        'city': profile.city,
        'description': profile.description,
        'work_hours': profile.workHours,
        'whatsapp_number': profile.whatsappNumber,
        'social_media': profile.socialMedia,
      };

      // إزالة القيم null
      data.removeWhere((key, value) => value == null);

      print('إنشاء profile جديد...');
      print('Data: $data');

      final response = await ApiClient.post(ApiUrls.providers, data);

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

  Future<bool> updateProfile(ProviderProfile profile) async {
    try {
      final data = {
        'category_id': profile.categoryId,
        'address': profile.address,
        'city': profile.city,
        'description': profile.description,
        'work_hours': profile.workHours,
        'whatsapp_number': profile.whatsappNumber,
        'social_media': profile.socialMedia,
      };

      data.removeWhere((key, value) => value == null);


      final response = await ApiClient.put(
        ApiUrls.providerById(profile.id.toString()),
        data,
      );

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

  // ====================
  // Get Profile Methods
  // ====================

  Future<ProviderProfile?> getMyProfile() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) {
        print('لا يوجد مستخدم مسجل دخول');
        return null;
      }

      print('جلب الملف الشخصي للمستخدم: ${user['id']}');

      // البحث عن المزود في قائمة جميع المزودين
      final response = await ApiClient.get(ApiUrls.providers);

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        final userId = user['id'].toString();

        // البحث عن المزود الحالي
        for (final data in providersData) {
          if (data['user_id'].toString() == userId) {
            print('تم العثور على الملف الشخصي');
            return ProviderProfile.fromJson(data);
          }
        }
      }

      print('لا يوجد ملف شخصي');
      return null;
    } catch (e) {
      print('خطأ في getMyProfile: $e');
      return null;
    }
  }

  Future<ProviderProfile?> getProfile(String providerId) async {
    try {
      print('جلب الملف الشخصي للمزود: $providerId');

      final response = await ApiClient.get(ApiUrls.providerById(providerId));

      if (response.success && response.data != null) {
        print('تم جلب الملف الشخصي بنجاح');
        return ProviderProfile.fromJson(response.data);
      }

      print('لا يوجد ملف شخصي للمزود: $providerId');
      return null;
    } catch (e) {
      print('خطأ في getProfile: $e');
      return null;
    }
  }

  // ====================F
  // Get Providers Lists
  // ====================

  Future<List<ProviderProfile>> getAllProviders() async {
    try {
      final response = await ApiClient.get(ApiUrls.providers);

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        final List<ProviderProfile> profiles = [];

        for (final data in providersData) {
          try {
            final profile = ProviderProfile.fromJson(data);
            if (profile.isComplete && profile.isVerified) {
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

  Future<List<ProviderProfile>> getAllProvidersAdmin() async {
    try {
      final response = await ApiClient.get(ApiUrls.providers);

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        final List<ProviderProfile> profiles = [];

        for (final data in providersData) {
          try {
            final profile = ProviderProfile.fromJson(data);
            profiles.add(profile); // جميع المزودين للأدمن
          } catch (e) {
            print('تجاهل ملف شخصي: $e');
            continue;
          }
        }

        return profiles;
      }

      return [];
    } catch (e) {
      print('خطأ في getAllProvidersAdmin: $e');
      return [];
    }
  }

  Future<List<ProviderProfile>> getFeaturedProviders() async {
    try {
      final response = await ApiClient.get(ApiUrls.featuredProviders);

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        final List<ProviderProfile> profiles = [];

        for (final data in providersData) {
          try {
            final profile = ProviderProfile.fromJson(data);
            profiles.add(profile);
          } catch (e) {
            print('تجاهل مقدم خدمة مميز: $e');
            continue;
          }
        }

        return profiles;
      }

      return [];
    } catch (e) {
      print('خطأ في getFeaturedProviders: $e');
      return [];
    }
  }

  Future<List<ProviderProfile>> getProvidersByService(String serviceId) async {
    try {
      final response = await ApiClient.get(ApiUrls.providersByService(serviceId));

      if (response.success && response.data != null) {
        // API returns {service: {...}, providers: [...]}
        final providersData = response.data['providers'] as List<dynamic>;
        final List<ProviderProfile> profiles = [];

        for (final data in providersData) {
          try {
            final profile = ProviderProfile.fromJson(data);
            profiles.add(profile);
          } catch (e) {
            print('تجاهل مزود خدمة: $e');
            continue;
          }
        }

        return profiles;
      }

      return [];
    } catch (e) {
      print('خطأ في getProvidersByService: $e');
      return [];
    }
  }

  Future<List<ProviderProfile>> getProvidersByCategory(String categoryId) async {
    try {
      final response = await ApiClient.get(ApiUrls.providersByCategory(categoryId));

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        final List<ProviderProfile> profiles = [];

        for (final data in providersData) {
          try {
            final profile = ProviderProfile.fromJson(data);
            profiles.add(profile);
          } catch (e) {
            print('تجاهل مزود خدمة: $e');
            continue;
          }
        }

        return profiles;
      }

      return [];
    } catch (e) {
      print('خطأ في getProvidersByCategory: $e');
      return [];
    }
  }

  // ====================
  // Search Methods
  // ====================

  Future<List<ProviderProfile>> searchProviders({
    String? query,
    String? city,
    String? serviceId,
    String? categoryId,
  }) async {
    try {
      Map<String, dynamic> params = {};
      if (query != null && query.isNotEmpty) params['search'] = query;
      if (city != null && city.isNotEmpty) params['city'] = city;
      if (serviceId != null) params['service_id'] = serviceId;
      if (categoryId != null) params['category_id'] = categoryId;

      final url = ApiUrls.buildSearchUrl(params);
      final response = await ApiClient.get(url);

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

  // ====================
  // Admin Operations
  // ====================

  Future<bool> updateVerificationStatus(String providerId, bool isVerified) async {
    try {
      final response = await ApiClient.patch(
        ApiUrls.updateProviderVerification(providerId),
        {'is_verified': isVerified},
      );
      return response.success;
    } catch (e) {
      print('خطأ في updateVerificationStatus: $e');
      return false;
    }
  }

  Future<bool> updateFeaturedStatus(String providerId, bool isFeatured) async {
    try {
      final response = await ApiClient.patch(
        ApiUrls.updateProviderFeatured(providerId),
        {'is_featured': isFeatured},
      );
      return response.success;
    } catch (e) {
      print('خطأ في updateFeaturedStatus: $e');
      return false;
    }
  }

  Future<bool> deleteProvider(String providerId) async {
    try {
      final response = await ApiClient.delete(ApiUrls.providerById(providerId));
      return response.success;
    } catch (e) {
      print('خطأ في deleteProvider: $e');
      return false;
    }
  }

  // ====================
  // Helper Methods
  // ====================

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
      return profile?.isComplete ?? false;
    } catch (e) {
      print('خطأ في isProfileComplete: $e');
      return false;
    }
  }

  // ====================
  // File Upload Methods (للمستقبل)
  // ====================

  Future<bool> uploadProfileImage(String providerId, File imageFile) async {
    try {
      final response = await ApiClient.postMultipart(
        endpoint: '/providers/$providerId/profile-image',
        fields: {},
        files: {'profile_image': imageFile},
      );
      return response.success;
    } catch (e) {
      print('خطأ في رفع صورة البروفايل: $e');
      return false;
    }
  }

  Future<bool> uploadPortfolioImages(String providerId, List<File> imageFiles) async {
    try {
      final response = await ApiClient.postMultipart(
        endpoint: '/providers/$providerId/portfolio-images',
        fields: {},
        fileArrays: {'portfolio_images': imageFiles},
      );
      return response.success;
    } catch (e) {
      print('خطأ في رفع صور المحفظة: $e');
      return false;
    }
  }
}