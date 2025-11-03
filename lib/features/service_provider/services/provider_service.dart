import 'dart:io';
import 'package:Lumixy/core/network/api_client.dart';
import 'package:Lumixy/core/network/api_urls.dart';
import '../models/provider_profile.dart';
import 'package:Lumixy/features/auth/services/auth_service.dart';
import 'package:Lumixy/models/service.dart';

class ProviderService {
  static final ProviderService _instance = ProviderService._internal();
  factory ProviderService() => _instance;
  ProviderService._internal();

  Future<List<Service>> getAllServices() async {
    try {
      final response = await ApiClient.get(ApiUrls.services);

      if (!response.success || response.data == null) return [];

      if (response.data is! List) return [];

      final List<dynamic> servicesData = response.data as List;

      return servicesData
          .map((data) {
        try {
          return Service.fromJson(data);
        } catch (e) {
          print('خطأ في تحليل service: $e');
          return null;
        }
      })
          .where((service) => service != null)
          .cast<Service>()
          .toList();
    } catch (e) {
      print('خطأ في جلب الخدمات: $e');
      return [];
    }
  }

  Future<List<Service>> getCategoryServices(int categoryId) async {
    try {
      final response = await ApiClient.get(
          ApiUrls.servicesByCategory(categoryId.toString())
      );

      if (!response.success || response.data == null) return [];

      // البيانات الصحيحة
      final data = response.data as Map<String, dynamic>;

      if (data['services'] == null || data['services'] is! List) return [];

      final List<dynamic> servicesData = data['services'] as List;

      return servicesData
          .map((data) {
        try {
          return Service.fromJson(data);
        } catch (e) {
          print('خطأ في تحليل service: $e');
          return null;
        }
      })
          .where((service) => service != null)
          .cast<Service>()
          .toList();
    } catch (e) {
      print('خطأ في جلب خدمات الـ category: $e');
      return [];
    }
  }

  Future<bool> saveProfile(ProviderProfile profile) async {
    try {
      final response = await ApiClient.get(ApiUrls.myProvider);

      if (response.success && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          final profileData = response.data as Map<String, dynamic>;

          if (profileData.isNotEmpty && profileData.containsKey('id')) {
            final existingId = profileData['id'];
            return await updateProfile(profile.copyWith(id: existingId));
          }
        }
      }

      return await createProfile(profile);
    } catch (e) {
      print('خطأ في saveProfile: $e');
      return false;
    }
  }

  Future<ProviderProfile?> getMyProfile() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) return null;

      final response = await ApiClient.get(ApiUrls.myProvider);

      if (!response.success || response.data == null) return null;

      if (response.data is! Map<String, dynamic>) return null;

      final profileData = response.data as Map<String, dynamic>;

      if (profileData.isEmpty || !profileData.containsKey('id')) {
        return null;
      }

      return ProviderProfile.fromJson(profileData);
    } catch (e) {
      print('خطأ في getMyProfile: $e');
      return null;
    }
  }

  Future<ProviderProfile?> getProfile(String providerId) async {
    try {
      final response = await ApiClient.get(ApiUrls.providerById(providerId));
      if (!response.success || response.data == null) return null;

      if (response.data is! Map<String, dynamic>) return null;

      final profileData = response.data as Map<String, dynamic>;

      if (profileData.isEmpty || !profileData.containsKey('id')) {
        return null;
      }

      return ProviderProfile.fromJson(profileData);
    } catch (e) {
      print('خطأ في getProfile: $e');
      return null;
    }
  }

  Future<bool> createProfile(ProviderProfile profile) async {
    try {
      final fields = <String, String>{
        if (profile.categoryId != null)
          'category_id': profile.categoryId.toString(),
        if (profile.address != null && profile.address!.isNotEmpty)
          'address': profile.address!,
        'city': profile.city,
        if (profile.description != null && profile.description!.isNotEmpty)
          'description': profile.description!,
        if (profile.workHours != null && profile.workHours!.isNotEmpty)
          'work_hours': profile.workHours!,
        if (profile.whatsappNumber != null && profile.whatsappNumber!.isNotEmpty)
          'whatsapp_number': profile.whatsappNumber!,
      };

      // Social Media
      if (profile.socialMedia != null && profile.socialMedia!.isNotEmpty) {
        profile.socialMedia!.forEach((key, value) {
          if (value != null && value.toString().trim().isNotEmpty) {
            fields['social_media[$key]'] = value.toString().trim();
          }
        });
      }

      // ✨ تحديث: استخدام Service IDs بشكل صحيح
      if (profile.services != null && profile.services!.isNotEmpty) {
        for (int i = 0; i < profile.services!.length; i++) {
          fields['service_ids[$i]'] = profile.services![i].id.toString();
        }
      }

      // Profile Image
      final files = <String, File>{};
      if (profile.profileImage != null &&
          !profile.profileImage!.startsWith('http') &&
          !profile.profileImage!.startsWith('storage/')) {
        final imageFile = File(profile.profileImage!);
        if (await imageFile.exists()) {
          files['profile_image'] = imageFile;
        }
      }

      // Portfolio Images
      final fileArrays = <String, List<File>>{};
      if (profile.portfolioImages != null && profile.portfolioImages!.isNotEmpty) {
        final portfolioFiles = <File>[];

        for (var portfolioImage in profile.portfolioImages!) {
          if (!portfolioImage.imageUrl.startsWith('http') &&
              !portfolioImage.imageUrl.startsWith('storage/')) {
            final imageFile = File(portfolioImage.imagePath);
            if (await imageFile.exists()) {
              portfolioFiles.add(imageFile);
            }
          }
        }

        if (portfolioFiles.isNotEmpty) {
          fileArrays['portfolio_images[]'] = portfolioFiles;
        }
      }

      final response = await ApiClient.postMultipart(
        endpoint: ApiUrls.providers,
        fields: fields,
        files: files,
        fileArrays: fileArrays,
      );

      if (response.success) {
        print('✅ تم إنشاء البروفايل بنجاح');
      } else {
        print('❌ فشل إنشاء البروفايل: ${response.message}');
      }

      return response.success;
    } catch (e) {
      print('❌ خطأ في createProfile: $e');
      return false;
    }
  }

  Future<bool> updateProfile(ProviderProfile profile) async {
    try {
      final fields = <String, String>{
        '_method': 'PUT',
        if (profile.categoryId != null)
          'category_id': profile.categoryId.toString(),
        if (profile.address != null)
          'address': profile.address!,
        'city': profile.city,
        if (profile.description != null)
          'description': profile.description!,
        if (profile.workHours != null)
          'work_hours': profile.workHours!,
        if (profile.whatsappNumber != null)
          'whatsapp_number': profile.whatsappNumber!,
      };

      // Social Media
      if (profile.socialMedia != null && profile.socialMedia!.isNotEmpty) {
        profile.socialMedia!.forEach((key, value) {
          if (value != null && value.toString().trim().isNotEmpty) {
            fields['social_media[$key]'] = value.toString().trim();
          }
        });
      }

      // ✨ تحديث: استخدام Service IDs بشكل صحيح
      if (profile.services != null && profile.services!.isNotEmpty) {
        for (int i = 0; i < profile.services!.length; i++) {
          fields['service_ids[$i]'] = profile.services![i].id.toString();
        }
      }

      // Profile Image
      final files = <String, File>{};
      if (profile.profileImage != null &&
          !profile.profileImage!.startsWith('http') &&
          !profile.profileImage!.startsWith('storage/')) {
        final imageFile = File(profile.profileImage!);
        if (await imageFile.exists()) {
          files['profile_image'] = imageFile;
        }
      }

      // Portfolio Images - فقط الصور الجديدة
      final fileArrays = <String, List<File>>{};
      final newPortfolioFiles = <File>[];

      if (profile.portfolioImages != null && profile.portfolioImages!.isNotEmpty) {
        for (var portfolioImage in profile.portfolioImages!) {
          // فقط الصور الجديدة (غير موجودة على السيرفر)
          if (!portfolioImage.imageUrl.startsWith('http') &&
              !portfolioImage.imageUrl.startsWith('storage/')) {
            final imageFile = File(portfolioImage.imagePath);
            if (await imageFile.exists()) {
              newPortfolioFiles.add(imageFile);
            }
          }
        }

        if (newPortfolioFiles.isNotEmpty) {
          fileArrays['portfolio_images[]'] = newPortfolioFiles;
          print('📤 سيتم رفع ${newPortfolioFiles.length} صورة جديدة للمعرض');
        }
      }

      final response = await ApiClient.postMultipart(
        endpoint: ApiUrls.providerById(profile.id.toString()),
        fields: fields,
        files: files,
        fileArrays: fileArrays,
      );

      if (response.success) {
        print('✅ تم تحديث البروفايل بنجاح');
      } else {
        print('❌ فشل تحديث البروفايل: ${response.message}');
      }

      return response.success;
    } catch (e) {
      print('❌ خطأ في updateProfile: $e');
      return false;
    }
  }

  Future<List<ProviderProfile>> getAllProviders() async {
    try {
      final response = await ApiClient.get(ApiUrls.providers);

      if (!response.success || response.data == null) return [];

      if (response.data is! List) return [];

      final List<dynamic> providersData = response.data as List;

      final List<ProviderProfile> profiles = [];

      for (final data in providersData) {
        try {
          final profile = ProviderProfile.fromJson(data);
          if (profile.isComplete && profile.isVerified) {
            profiles.add(profile);
          }
        } catch (e) {
          print('خطأ في تحليل provider: $e');
          continue;
        }
      }

      return profiles;
    } catch (e) {
      print('خطأ في getAllProviders: $e');
      return [];
    }
  }

  Future<List<ProviderProfile>> getFeaturedProviders() async {
    try {
      final response = await ApiClient.get(ApiUrls.featuredProviders);

      if (!response.success || response.data == null) return [];

      if (response.data is! List) return [];

      final List<dynamic> providersData = response.data as List;

      final List<ProviderProfile> profiles = [];

      for (final data in providersData) {
        try {
          final profile = ProviderProfile.fromJson(data);
          profiles.add(profile);
        } catch (e) {
          print('خطأ في تحليل featured provider: $e');
          continue;
        }
      }

      return profiles;
    } catch (e) {
      print('خطأ في getFeaturedProviders: $e');
      return [];
    }
  }
  Future<List<ProviderProfile>> getNewProviders() async {
    try {
      final response = await ApiClient.get(ApiUrls.newProviders);

      if (!response.success || response.data == null) return [];

      if (response.data is! List) return [];

      final List<dynamic> providersData = response.data as List;

      final List<ProviderProfile> profiles = [];

      for (final data in providersData) {
        try {
          final profile = ProviderProfile.fromJson(data);
          profiles.add(profile);
        } catch (e) {
          print('خطأ في تحليل featured provider: $e');
          continue;
        }
      }

      return profiles;
    } catch (e) {
      print('خطأ في getFeaturedProviders: $e');
      return [];
    }
  }

  Future<bool> deletePortfolioImage(int imageId) async {
    try {
      final response = await ApiClient.delete(
        ApiUrls.deletePortfolioImage(imageId.toString()),
      );

      if (response.success) {
        print('✅ تم حذف صورة المعرض');
      } else {
        print('❌ فشل حذف صورة المعرض: ${response.message}');
      }

      return response.success;
    } catch (e) {
      print('❌ خطأ في deletePortfolioImage: $e');
      return false;
    }
  }

  Future<bool> hasProfile() async {
    try {
      final profile = await getMyProfile();
      return profile != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isProfileComplete() async {
    try {
      final profile = await getMyProfile();
      return profile?.isComplete ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<List<ProviderProfile>> getAllProvidersAdmin() async {
    try {
      final response = await ApiClient.get(ApiUrls.providers);

      if (!response.success || response.data == null) return [];

      if (response.data is! List) return [];

      final List<dynamic> providersData = response.data as List;

      final List<ProviderProfile> profiles = [];

      for (final data in providersData) {
        try {
          final profile = ProviderProfile.fromJson(data);
          profiles.add(profile);
        } catch (e) {
          print('خطأ في تحليل admin provider: $e');
          continue;
        }
      }

      return profiles;
    } catch (e) {
      print('خطأ في getAllProvidersAdmin: $e');
      return [];
    }
  }

}