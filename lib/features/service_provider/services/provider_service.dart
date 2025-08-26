
import 'package:service_hub/core/network/api_client.dart';
import 'package:service_hub/core/network/api_urls.dart';
import 'package:service_hub/features/service_provider/models/provider_profile.dart';

class ProviderService {
  static final ProviderService _instance = ProviderService._internal();
  factory ProviderService() => _instance;
  ProviderService._internal();

  Future<ProviderProfile?> getProfile(String userId) async {
    try {
      final response = await ApiClient.get('/providers/profile/$userId');

      if (response.success && response.data != null) {
        return ProviderProfile.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error getting provider profile: $e');
      return null;
    }
  }

  /// إنشاء أو تحديث الملف الشخصي
  Future<bool> saveProfile(ProviderProfile profile) async {
    try {
      final response = await ApiClient.post('/providers/profile', profile.toJson());
      return response.success;
    } catch (e) {
      print('Error saving provider profile: $e');
      return false;
    }
  }

  /// حذف الملف الشخصي
  Future<bool> deleteProfile(String userId) async {
    try {
      final response = await ApiClient.delete('/providers/profile/$userId');
      return response.success;
    } catch (e) {
      print('Error deleting provider profile: $e');
      return false;
    }
  }

  /// الحصول على جميع مقدمي الخدمات
  Future<List<ProviderProfile>> getAllProviders() async {
    try {
      final response = await ApiClient.get(ApiUrls.providers);

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        return providersData
            .map((data) => ProviderProfile.fromJson(data))
            .where((profile) => profile.isComplete)
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting all providers: $e');
      return [];
    }
  }

  /// البحث عن مقدمي الخدمات
  Future<List<ProviderProfile>> searchProviders({
    String? query,
    String? serviceType,
    String? city,
  }) async {
    try {
      final params = <String, dynamic>{};

      if (query != null && query.isNotEmpty) params['q'] = query;
      if (serviceType != null) params['service_type'] = serviceType;
      if (city != null) params['city'] = city;

      final searchUrl = ApiUrls.withParams(ApiUrls.searchProviders, params);
      final response = await ApiClient.get(searchUrl);

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        return providersData
            .map((data) => ProviderProfile.fromJson(data))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error searching providers: $e');
      return [];
    }
  }

  /// الحصول على مقدمي الخدمات حسب النوع
  Future<List<ProviderProfile>> getProvidersByType(String serviceType) async {
    try {
      final response = await ApiClient.get('/providers?service_type=$serviceType');

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        return providersData
            .map((data) => ProviderProfile.fromJson(data))
            .where((profile) => profile.isComplete)
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting providers by type: $e');
      return [];
    }
  }

  /// الحصول على مقدمي الخدمات حسب المدينة
  Future<List<ProviderProfile>> getProvidersByCity(String city) async {
    try {
      final response = await ApiClient.get('/providers?city=$city');

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        return providersData
            .map((data) => ProviderProfile.fromJson(data))
            .where((profile) => profile.isComplete)
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting providers by city: $e');
      return [];
    }
  }

  /// الحصول على أفضل مقدمي الخدمات
  Future<List<ProviderProfile>> getTopRatedProviders({int limit = 10}) async {
    try {
      final response = await ApiClient.get(ApiUrls.featuredProviders);

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        List<ProviderProfile> providers = providersData
            .map((data) => ProviderProfile.fromJson(data))
            .where((profile) => profile.isComplete)
            .toList();

        // ترتيب حسب التقييم
        providers.sort((a, b) => b.rating.compareTo(a.rating));
        return providers.take(limit).toList();
      }
      return [];
    } catch (e) {
      print('Error getting top rated providers: $e');
      return [];
    }
  }

  /// الحصول على مقدمي الخدمات الموثقين
  Future<List<ProviderProfile>> getVerifiedProviders() async {
    try {
      final response = await ApiClient.get('/providers?verified=1');

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        return providersData
            .map((data) => ProviderProfile.fromJson(data))
            .where((profile) => profile.isComplete && profile.isVerified)
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting verified providers: $e');
      return [];
    }
  }

  /// الحصول على مقدم خدمة واحد بالـ ID
  Future<ProviderProfile?> getProviderById(String providerId) async {
    try {
      final response = await ApiClient.get(ApiUrls.providerById(providerId));

      if (response.success && response.data != null) {
        return ProviderProfile.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error getting provider by ID: $e');
      return null;
    }
  }

  /// إضافة تقييم لمقدم خدمة
  Future<bool> addRating(String providerId, double rating, {String? review}) async {
    try {
      final response = await ApiClient.post('/providers/$providerId/rating', {
        'rating': rating,
        if (review != null) 'review': review,
      });

      return response.success;
    } catch (e) {
      print('Error adding rating: $e');
      return false;
    }
  }

  /// تحديث حالة التوثيق
  Future<bool> updateVerificationStatus(String providerId, bool isVerified) async {
    try {
      final response = await ApiClient.put('/providers/$providerId/verify', {
        'is_verified': isVerified,
      });

      return response.success;
    } catch (e) {
      print('Error updating verification status: $e');
      return false;
    }
  }

  /// الحصول على إحصائيات عامة
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final response = await ApiClient.get('/providers/statistics');

      if (response.success && response.data != null) {
        return response.data;
      }
      return {};
    } catch (e) {
      print('Error getting statistics: $e');
      return {};
    }
  }

  /// تصفية متقدمة
  Future<List<ProviderProfile>> advancedSearch({
    String? query,
    String? serviceType,
    String? city,
    double? minRating,
    bool? isVerified,
    String? sortBy,
    bool ascending = true,
  }) async {
    try {
      final params = <String, dynamic>{};

      if (query != null && query.isNotEmpty) params['q'] = query;
      if (serviceType != null) params['service_type'] = serviceType;
      if (city != null) params['city'] = city;
      if (minRating != null) params['min_rating'] = minRating;
      if (isVerified != null) params['verified'] = isVerified ? 1 : 0;
      if (sortBy != null) {
        params['sort_by'] = sortBy;
        params['sort_order'] = ascending ? 'asc' : 'desc';
      }

      final searchUrl = ApiUrls.withParams('/providers/advanced-search', params);
      final response = await ApiClient.get(searchUrl);

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        return providersData
            .map((data) => ProviderProfile.fromJson(data))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error in advanced search: $e');
      return [];
    }
  }

  /// رفع صورة للملف الشخصي
  Future<String?> uploadProfileImage(String filePath) async {
    try {
      // هنا يمكنك إضافة كود رفع الصورة
      // مثال باستخدام multipart request

      // final request = http.MultipartRequest('POST', Uri.parse('${ApiClient.baseUrl}/upload/profile-image'));
      // request.files.add(await http.MultipartFile.fromPath('image', filePath));
      // request.headers.addAll(ApiClient._headers);

      // final response = await request.send();
      // if (response.statusCode == 200) {
      //   final responseData = await response.stream.bytesToString();
      //   final jsonData = json.decode(responseData);
      //   return jsonData['data']['url'];
      // }

      return null;
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  /// رفع صورة للمعرض
  Future<String?> uploadPortfolioImage(String filePath) async {
    try {
      // مثل uploadProfileImage ولكن لصور المعرض
      return null;
    } catch (e) {
      print('Error uploading portfolio image: $e');
      return null;
    }
  }

  /// الحصول على مقدمي الخدمات لفئة معينة
  Future<List<ProviderProfile>> getProvidersByCategory(String categoryId) async {
    try {
      final response = await ApiClient.get(ApiUrls.categoryProviders(categoryId));

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        return providersData
            .map((data) => ProviderProfile.fromJson(data))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting providers by category: $e');
      return [];
    }
  }

  /// الحصول على مقدمي خدمة لخدمة معينة
  Future<List<ProviderProfile>> getProvidersByService(String serviceId) async {
    try {
      final response = await ApiClient.get(ApiUrls.serviceProviders(serviceId));

      if (response.success && response.data != null) {
        final List<dynamic> providersData = response.data;
        return providersData
            .map((data) => ProviderProfile.fromJson(data))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error getting providers by service: $e');
      return [];
    }
  }

  /// تحديث خدمات مقدم الخدمة
  Future<bool> updateProviderServices(String providerId, List<String> serviceIds) async {
    try {
      final response = await ApiClient.put(ApiUrls.updateServices, {
        'provider_id': providerId,
        'service_ids': serviceIds,
      });

      return response.success;
    } catch (e) {
      print('Error updating provider services: $e');
      return false;
    }
  }

  /// الحصول على ملف مقدم الخدمة الخاص بي
  Future<ProviderProfile?> getMyProfile() async {
    try {
      final response = await ApiClient.get(ApiUrls.myProfile);

      if (response.success && response.data != null) {
        return ProviderProfile.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print('Error getting my profile: $e');
      return null;
    }
  }
}