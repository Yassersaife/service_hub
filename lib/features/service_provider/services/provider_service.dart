import 'dart:io';
import 'dart:convert';
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
        return await updateProfileWithFiles(profile);
      } else {
        print('إنشاء ملف شخصي جديد');
        return await createProfileWithFiles(profile);
      }
    } catch (e) {
      print('خطأ في saveProfile: $e');
      return false;
    }
  }

  Future<bool> createProfileWithFiles(ProviderProfile profile) async {
    try {
      final fields = <String, String>{
        'service_type': profile.serviceType,
        'city': profile.city,
        'address': profile.address ?? '',
        'description': profile.description ?? '',
        'work_hours': profile.workHours ?? '',
        'whatsappNumber': profile.whatsappNumber ?? '',
      };

      fields['social_media'] = jsonEncode(profile.socialMedia.isNotEmpty ? profile.socialMedia : {});

      // إضافة specialties كـ JSON (مع تأكد إن Backend يقبل JSON)
      if (profile.specialties.isNotEmpty) {
        fields['selected_services'] = jsonEncode(profile.specialties);

        // إضافة أسعار افتراضية كـ JSON object
        Map<String, String> servicesPrices = {};
        for (String service in profile.specialties) {
          servicesPrices[service] = "0";
        }
        fields['services_prices'] = jsonEncode(servicesPrices);
      } else {
        // قيم افتراضية فارغة
        fields['selected_services'] = jsonEncode([]);
        fields['services_prices'] = jsonEncode({});
      }

      // تحضير الملفات
      final files = <String, File>{};
      final fileArrays = <String, List<File>>{};

      // صورة البروفايل
      if (profile.profileImage != null &&
          profile.profileImage!.isNotEmpty &&
          File(profile.profileImage!).existsSync()) {
        files['profile_image'] = File(profile.profileImage!);
      }

      // صور المحفظة
      final portfolioFiles = profile.portfolioImages
          .where((path) => File(path).existsSync())
          .map((path) => File(path))
          .toList();

      if (portfolioFiles.isNotEmpty) {
        fileArrays['portfolio_images[]'] = portfolioFiles;
      }

      print('إرسال البيانات...');
      print('Fields: $fields');
      print('Files: ${files.length}');
      print('Portfolio files: ${portfolioFiles.length}');

      // إرسال الطلب
      final response = await ApiClient.postMultipart(
        endpoint: '/providers',
        fields: fields,
        files: files,
        fileArrays: fileArrays,
      );

      print('نتيجة الإنشاء: ${response.success}');
      if (!response.success) {
        print('خطأ في الإنشاء: ${response.message}');
      }

      return response.success;
    } catch (e) {
      print('خطأ في createProfileWithFiles: $e');
      return false;
    }
  }

  Future<bool> updateProfileWithFiles(ProviderProfile profile) async {
    try {
      final fields = <String, String>{
        'service_type': profile.serviceType,
        'city': profile.city,
        'address': profile.address ?? '',
        'description': profile.description ?? '',
        'work_hours': profile.workHours ?? '',
        'whatsappNumber': profile.whatsappNumber ?? '',
      };

      if (profile.socialMedia.isNotEmpty) {
        fields['social_media'] = jsonEncode(profile.socialMedia);
      }

      if (profile.specialties.isNotEmpty) {
        fields['selected_services'] = jsonEncode(profile.specialties);

        Map<String, String> servicesPrices = {};
        for (String service in profile.specialties) {
          servicesPrices[service] = "0";
        }
        fields['services_prices'] = jsonEncode(servicesPrices);
      }

      final files = <String, File>{};
      final fileArrays = <String, List<File>>{};

      if (profile.profileImage != null &&
          profile.profileImage!.isNotEmpty &&
          File(profile.profileImage!).existsSync()) {
        files['profile_image'] = File(profile.profileImage!);
      }

      final newPortfolioFiles = profile.portfolioImages
          .where((path) => File(path).existsSync())
          .map((path) => File(path))
          .toList();

      if (newPortfolioFiles.isNotEmpty) {
        fileArrays['portfolio_images[]'] = newPortfolioFiles;
      }

      print('تحديث البيانات...');
      print('Fields: $fields');
      print('New files: ${files.length}');
      print('New portfolio files: ${newPortfolioFiles.length}');

      // إرسال الطلب
      final response = await ApiClient.putMultipart(
        endpoint: '/providers/1',
        fields: fields,
        files: files,
        fileArrays: fileArrays,
      );

      print('نتيجة التحديث: ${response.success}');
      if (!response.success) {
        print('خطأ في التحديث: ${response.message}');
      }

      return response.success;
    } catch (e) {
      print('خطأ في updateProfileWithFiles: $e');
      return false;
    }
  }

  /// إنشاء ملف شخصي بدون ملفات (للبيانات فقط)
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

  /// تحديث الملف الشخصي بدون ملفات
  Future<bool> updateProfile(ProviderProfile profile) async {
    try {
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

      final response = await ApiClient.get('/providers/my/profile');

      if (response.success && response.data != null) {
        print('البيانات المستلمة: ${response.data}');
        print('نوع البيانات: ${response.data.runtimeType}');

        final profile = ProviderProfile.fromJson(response.data);

        if (profile.userId.isNotEmpty) {
          print('تم جلب الملف الشخصي: ${profile.name}');

          // تحويل المسارات النسبية إلى URLs كاملة
          ProviderProfile updatedProfile = profile;

          // معالجة صورة البروفايل
          if (profile.profileImage != null &&
              profile.profileImage!.isNotEmpty &&
              !profile.profileImage!.startsWith('http')) {
            final fullImageUrl = '${ApiClient.baseUrl.replaceAll('/api', '')}/storage/${profile.profileImage}';
            print('Converting profile image: ${profile.profileImage} -> $fullImageUrl');
            updatedProfile = profile.copyWith(profileImage: fullImageUrl);
          }

          // معالجة صور المحفظة
          final fullPortfolioImages = profile.portfolioImages.map((path) {
            if (path.isNotEmpty && !path.startsWith('http')) {
              final fullUrl = '${ApiClient.baseUrl.replaceAll('/api', '')}/storage/$path';
              print('Converting portfolio image: $path -> $fullUrl');
              return fullUrl;
            }
            return path;
          }).toList();

          updatedProfile = updatedProfile.copyWith(portfolioImages: fullPortfolioImages);

          print('Final profile data:');
          print('- Profile image: ${updatedProfile.profileImage}');
          print('- Portfolio images count: ${updatedProfile.portfolioImages.length}');
          print('- Social media: ${updatedProfile.socialMedia}');
          print('- Specialties: ${updatedProfile.specialties}');

          return updatedProfile;
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

        final profile = ProviderProfile.fromJson(response.data);

        if (profile.userId.isNotEmpty) {
          print('تم جلب الملف الشخصي: ${profile.name}');

          // تحويل المسارات إلى URLs كاملة
          ProviderProfile updatedProfile = profile;

          if (profile.profileImage != null &&
              profile.profileImage!.isNotEmpty &&
              !profile.profileImage!.startsWith('http')) {
            updatedProfile = profile.copyWith(
                profileImage: '${ApiClient.baseUrl.replaceAll('/api', '')}/storage/${profile.profileImage}'
            );
          }

          final fullPortfolioImages = profile.portfolioImages.map((path) {
            if (!path.startsWith('http')) {
              return '${ApiClient.baseUrl.replaceAll('/api', '')}/storage/$path';
            }
            return path;
          }).toList();

          updatedProfile = updatedProfile.copyWith(portfolioImages: fullPortfolioImages);

          return updatedProfile;
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

            if (profile.isProfileComplete && profile.isVerified ) {
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
            if (profile.isProfileComplete && profile.isVerified) {
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
      final response = await ApiClient.delete('/auth/account/delete');
      return response.success;
    } catch (e) {
      print('خطأ في حذف الحساب: $e');
      return false;
    }
  }
}