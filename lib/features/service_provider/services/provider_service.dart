import 'dart:io';
import 'dart:convert';
import 'package:Lumixy/core/network/api_client.dart';
import 'package:Lumixy/core/network/api_urls.dart';
import '../models/provider_profile.dart';
import 'package:Lumixy/features/auth/services/auth_service.dart';

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
      print('=== إنشاء ملف شخصي جديد ===');

      final fields = <String, String>{
        if (profile.categoryId != null) 'category_id': profile.categoryId.toString(),
        if (profile.address != null) 'address': profile.address!,
        'city': profile.city,
        if (profile.description != null) 'description': profile.description!,
        if (profile.workHours != null) 'work_hours': profile.workHours!,
        if (profile.whatsappNumber != null) 'whatsapp_number': profile.whatsappNumber!,
      };

      // إضافة social_media كـ JSON string (السيرفر يتوقع array)
      if (profile.socialMedia != null && profile.socialMedia!.isNotEmpty) {
        fields['social_media'] = jsonEncode(profile.socialMedia);
      }

      // إضافة service_ids كـ array منفصل
      if (profile.services != null && profile.services!.isNotEmpty) {
        for (int i = 0; i < profile.services!.length; i++) {
          fields['service_ids[$i]'] = profile.services![i]['id'].toString();
        }
      }

      // تحضير الملفات - إصلاح مسارات الصور
      final files = <String, File>{};
      if (profile.profileImage != null &&
          !profile.profileImage!.startsWith('http') &&
          !profile.profileImage!.startsWith('storage/')) {
        final imageFile = File(profile.profileImage!);
        if (await imageFile.exists()) {
          files['profile_image'] = imageFile;
          print('صورة البروفايل: ${profile.profileImage}');
        } else {
          print('ملف صورة البروفايل غير موجود: ${profile.profileImage}');
        }
      }

      // تحضير صور المعرض - إصلاح مشكلة رفع الصور
      final fileArrays = <String, List<File>>{};
      if (profile.portfolioImages != null && profile.portfolioImages!.isNotEmpty) {
        final portfolioFiles = <File>[];

        for (String imagePath in profile.portfolioImages!) {
          // تجاهل الصور المرفوعة مسبقاً
          if (!imagePath.startsWith('http') && !imagePath.startsWith('storage/')) {
            final imageFile = File(imagePath);
            if (await imageFile.exists()) {
              portfolioFiles.add(imageFile);
              print('صورة معرض: $imagePath');
            } else {
              print('ملف صورة معرض غير موجود: $imagePath');
            }
          }
        }

        if (portfolioFiles.isNotEmpty) {
          fileArrays['portfolio_images[]'] = portfolioFiles; // إضافة [] للـ Laravel
          print('عدد صور المعرض للرفع: ${portfolioFiles.length}');
        }
      }

      print('Fields: $fields');
      print('Files: ${files.keys.toList()}');
      print('File Arrays: ${fileArrays.keys.toList()}');

      final response = await ApiClient.postMultipart(
        endpoint: ApiUrls.providers,
        fields: fields,
        files: files,
        fileArrays: fileArrays,
      );

      print('نتيجة الإنشاء: ${response.success}');
      if (!response.success) {
        print('خطأ في الإنشاء: ${response.message}');
        print('Response Data: ${response.data}');
      } else {
        print('تم إنشاء الملف الشخصي بنجاح');
      }

      return response.success;
    } catch (e) {
      print('خطأ في createProfile: $e');
      return false;
    }
  }

  Future<bool> updateProfile(ProviderProfile profile) async {
    try {
      print('=== تحديث الملف الشخصي ===');

      final fields = <String, String>{
        if (profile.categoryId != null) 'category_id': profile.categoryId.toString(),
        if (profile.address != null) 'address': profile.address!,
        'city': profile.city,
        if (profile.description != null) 'description': profile.description!,
        if (profile.workHours != null) 'work_hours': profile.workHours!,
        if (profile.whatsappNumber != null) 'whatsapp_number': profile.whatsappNumber!,
        '_method': 'PUT', // Laravel method spoofing
      };

      // إضافة social_media كـ JSON string محسّن
      if (profile.socialMedia != null && profile.socialMedia!.isNotEmpty) {
        // إزالة القيم الفارغة
        final cleanedSocialMedia = <String, dynamic>{};
        profile.socialMedia!.forEach((key, value) {
          if (value != null && value.toString().trim().isNotEmpty) {
            cleanedSocialMedia[key] = value.toString().trim();
          }
        });

        if (cleanedSocialMedia.isNotEmpty) {
          fields['social_media'] = jsonEncode(cleanedSocialMedia);
        }
      }

      // إضافة service_ids كـ array منفصل
      if (profile.services != null && profile.services!.isNotEmpty) {
        for (int i = 0; i < profile.services!.length; i++) {
          fields['service_ids[$i]'] = profile.services![i]['id'].toString();
        }
      }

      // تحضير الملفات الجديدة فقط
      final files = <String, File>{};
      if (profile.profileImage != null &&
          !profile.profileImage!.startsWith('http') &&
          !profile.profileImage!.startsWith('storage/')) {
        final imageFile = File(profile.profileImage!);
        if (await imageFile.exists()) {
          files['profile_image'] = imageFile;
          print('تحديث صورة البروفايل: ${profile.profileImage}');
        }
      }

      // تحضير صور المعرض الجديدة - إصلاح مشكلة التحديث
      final fileArrays = <String, List<File>>{};
      if (profile.portfolioImages != null && profile.portfolioImages!.isNotEmpty) {
        final newPortfolioFiles = <File>[];

        for (String imagePath in profile.portfolioImages!) {
          // رفع الصور الجديدة فقط
          if (!imagePath.startsWith('http') && !imagePath.startsWith('storage/')) {
            final imageFile = File(imagePath);
            if (await imageFile.exists()) {
              newPortfolioFiles.add(imageFile);
              print('صورة معرض جديدة: $imagePath');
            }
          }
        }

        if (newPortfolioFiles.isNotEmpty) {
          fileArrays['portfolio_images[]'] = newPortfolioFiles;
          print('عدد صور المعرض الجديدة: ${newPortfolioFiles.length}');
        }
      }


      final response = await ApiClient.postMultipart(
        endpoint: ApiUrls.providerById(profile.id.toString()),
        fields: fields,
        files: files,
        fileArrays: fileArrays,
      );

      print('نتيجة التحديث: ${response.success}');
      if (!response.success) {
        print('خطأ في التحديث: ${response.message}');
        print('Response Data: ${response.data}');
      } else {
        print('تم تحديث الملف الشخصي بنجاح');
      }

      return response.success;
    } catch (e) {
      print('خطأ في updateProfile: $e');
      return false;
    }
  }

  // ====================
  // Get Profile Methods - محسّن
  // ====================

  Future<ProviderProfile?> getMyProfile() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) {
        print('لا يوجد مستخدم مسجل دخول');
        return null;
      }

      print('جلب الملف الشخصي للمستخدم: ${user['id']}');

      final response = await ApiClient.get(ApiUrls.providers);

      if (response.success && response.data != null) {
        print('Response data type: ${response.data.runtimeType}');

        final List<dynamic> providersData = response.data is List
            ? response.data
            : [response.data]; // في حالة كان object واحد

        final userId = user['id'].toString();

        for (final data in providersData) {
          if (data['user_id'].toString() == userId) {
            print('تم العثور على الملف الشخصي');
            print('Provider data: $data');
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
        print('Provider data: ${response.data}');
        return ProviderProfile.fromJson(response.data);
      }

      print('لا يوجد ملف شخصي للمزود: $providerId');
      return null;
    } catch (e) {
      print('خطأ في getProfile: $e');
      return null;
    }
  }

  // ====================
  // Get Providers Lists - محسّن
  // ====================

  Future<List<ProviderProfile>> getAllProviders({bool includeWithCategories = true}) async {
    try {
      print('=== جلب جميع المزودين ===');

      String endpoint = includeWithCategories
          ? '${ApiUrls.providers}?include=category,services,user'
          : ApiUrls.providers;

      final response = await ApiClient.get(endpoint);

      if (response.success && response.data != null) {
        print('Response received - Type: ${response.data.runtimeType}');

        final List<dynamic> providersData = response.data is List
            ? response.data
            : [response.data];

        print('عدد المزودين في الاستجابة: ${providersData.length}');

        final List<ProviderProfile> profiles = [];

        for (final data in providersData) {
          try {
            print('معالجة مزود: ${data['id']}');
            final profile = ProviderProfile.fromJson(data);

            if (profile.isComplete && profile.isVerified) {
              profiles.add(profile);
              print('تمت إضافة المزود: ${profile.displayName}');
            } else {
              print('تجاهل مزود غير مكتمل: ${profile.displayName}');
            }
          } catch (e) {
            print('خطأ في تحليل بيانات مزود: $e');
            print('Data was: $data');
            continue;
          }
        }

        print('عدد المزودين المفلترين: ${profiles.length}');
        return profiles;
      }

      print('لا توجد بيانات في الاستجابة');
      return [];
    } catch (e) {
      print('خطأ في getAllProviders: $e');
      return [];
    }
  }

  Future<List<ProviderProfile>> getAllProvidersAdmin() async {
    try {
      print('=== جلب جميع المزودين للإدارة ===');

      final response = await ApiClient.get('${ApiUrls.providers}?include=category,services,user');

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data is List
            ? response.data
            : [response.data];

        final List<ProviderProfile> profiles = [];

        for (final data in providersData) {
          try {
            final profile = ProviderProfile.fromJson(data);
            profiles.add(profile); // إضافة جميع المزودين للإدارة
            print('تمت إضافة مزود للإدارة: ${profile.displayName}');
          } catch (e) {
            print('تجاهل ملف شخصي في الإدارة: $e');
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
      print('=== جلب المزودين المميزين ===');

      final response = await ApiClient.get('${ApiUrls.featuredProviders}?include=category,services,user');

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data is List
            ? response.data
            : [response.data];

        final List<ProviderProfile> profiles = [];

        for (final data in providersData) {
          try {
            final profile = ProviderProfile.fromJson(data);
            profiles.add(profile);
            print('تمت إضافة مزود مميز: ${profile.displayName}');
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

  // جلب مزودين حسب الفئة
  Future<List<ProviderProfile>> getProvidersByCategory(int categoryId) async {
    try {
      print('=== جلب مزودين حسب الفئة: $categoryId ===');

      final response = await ApiClient.get('${ApiUrls.providers}?category_id=$categoryId&include=category,services,user');

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data is List
            ? response.data
            : [response.data];

        final List<ProviderProfile> profiles = [];

        for (final data in providersData) {
          try {
            final profile = ProviderProfile.fromJson(data);
            if (profile.isComplete && (profile.categoryId == categoryId || profile.categoryName?.isNotEmpty == true)) {
              profiles.add(profile);
            }
          } catch (e) {
            print('تجاهل مزود في الفئة: $e');
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

  // جلب مزودين حسب المدينة
  Future<List<ProviderProfile>> getProvidersByCity(String city) async {
    try {
      print('=== جلب مزودين حسب المدينة: $city ===');

      final response = await ApiClient.get('${ApiUrls.providers}?city=$city&include=category,services,user');

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data is List
            ? response.data
            : [response.data];

        final List<ProviderProfile> profiles = [];

        for (final data in providersData) {
          try {
            final profile = ProviderProfile.fromJson(data);
            if (profile.isComplete && profile.city.toLowerCase() == city.toLowerCase()) {
              profiles.add(profile);
            }
          } catch (e) {
            print('تجاهل مزود في المدينة: $e');
            continue;
          }
        }

        return profiles;
      }

      return [];
    } catch (e) {
      print('خطأ في getProvidersByCity: $e');
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

  // // حذف صور من المعرض
  // Future<bool> deletePortfolioImage(String providerId, String imagePath) async {
  //   try {
  //     final response = await ApiClient.delete(
  //       '${ApiUrls.providerById(providerId)}/portfolio-image',
  //       {'image_path': imagePath},
  //     );
  //     return response.success;
  //   } catch (e) {
  //     print('خطأ في deletePortfolioImage: $e');
  //     return false;
  //   }
  // }

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

  Future<bool> updateProfileImage(String providerId, String imagePath) async {
    try {
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        print('ملف الصورة غير موجود: $imagePath');
        return false;
      }

      final response = await ApiClient.postMultipart(
        endpoint: ApiUrls.providerById(providerId),
        fields: {'_method': 'PUT'},
        files: {'profile_image': imageFile},
      );

      return response.success;
    } catch (e) {
      print('خطأ في updateProfileImage: $e');
      return false;
    }
  }

  // إضافة صور للمعرض
  Future<bool> addPortfolioImages(String providerId, List<String> imagePaths) async {
    try {
      final imageFiles = <File>[];

      for (String path in imagePaths) {
        final file = File(path);
        if (await file.exists()) {
          imageFiles.add(file);
        }
      }

      if (imageFiles.isEmpty) {
        print('لا توجد صور صالحة للإضافة');
        return false;
      }

      final response = await ApiClient.postMultipart(
        endpoint: '${ApiUrls.providerById(providerId)}/portfolio',
        fields: {},
        fileArrays: {'portfolio_images[]': imageFiles},
      );

      return response.success;
    } catch (e) {
      print('خطأ في addPortfolioImages: $e');
      return false;
    }
  }

  // البحث في المزودين
  Future<List<ProviderProfile>> searchProviders(String query) async {
    try {
      print('=== البحث في المزودين: $query ===');

      final response = await ApiClient.get(
          '${ApiUrls.providers}?search=$query&include=category,services,user'
      );

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data is List
            ? response.data
            : [response.data];

        final List<ProviderProfile> profiles = [];

        for (final data in providersData) {
          try {
            final profile = ProviderProfile.fromJson(data);
            if (profile.isComplete) {
              profiles.add(profile);
            }
          } catch (e) {
            print('تجاهل نتيجة بحث: $e');
            continue;
          }
        }

        return profiles;
      }

      return [];
    } catch (e) {
      print('خطأ في searchProviders: $e');
      return [];
    }
  }
}