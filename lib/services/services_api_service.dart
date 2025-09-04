// lib/services/services_api_service.dart
import '../core/network/api_client.dart';
import '../core/network/api_urls.dart';
import '../models/category.dart';
import '../models/service.dart';

class ServicesApiService {
  // ====================
  // Categories Methods
  // ====================

  static Future<List<Category>> getAllCategories() async {
    try {
      final response = await ApiClient.get(ApiUrls.categories);

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data;
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting categories from API: $e');
      return [];
    }
  }

  /// جلب فئة محددة بالـ ID
  static Future<Category?> getCategoryById(String categoryId) async {
    try {
      final response = await ApiClient.get(ApiUrls.categoryById(categoryId));

      if (response.success && response.data != null) {
        return Category.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting category by ID: $e');
      return null;
    }
  }

  // ====================
  // Services Methods
  // ====================

  static Future<List<Service>> getAllServices({
    String? categoryId,
    String? search,
  }) async {
    try {
      final url = ApiUrls.buildServicesUrl(
        categoryId: categoryId,
        search: search,
      );
      print('===================== $url ');
      final response = await ApiClient.get(url);

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data;
        return data.map((json) => Service.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting services from API: $e');
      return [];
    }
  }

  static Future<Service?> getServiceById(String serviceId) async {
    try {
      final response = await ApiClient.get(ApiUrls.serviceById(serviceId));

      if (response.success && response.data != null) {
        return Service.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting service by ID: $e');
      return null;
    }
  }

  /// جلب الخدمات حسب الفئة
  static Future<List<Service>> getServicesByCategory(String categoryId) async {
    try {
      return await getAllServices(categoryId: categoryId);
    } catch (e) {
      print('Error getting services by category: $e');
      return [];
    }
  }

  /// البحث في الخدمات
  static Future<List<Service>> searchServices(String searchTerm) async {
    try {
      return await getAllServices(search: searchTerm);
    } catch (e) {
      print('Error searching services: $e');
      return [];
    }
  }

  // ====================
  // Providers Methods
  // ====================

  /// جلب جميع مقدمي الخدمات
  static Future<List<Map<String, dynamic>>> getAllProviders() async {
    try {
      final response = await ApiClient.get(ApiUrls.providers);

      if (response.success && response.data != null) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting providers: $e');
      return [];
    }
  }

  /// جلب المزودين المميزين
  static Future<List<Map<String, dynamic>>> getFeaturedProviders() async {
    try {
      final response = await ApiClient.get(ApiUrls.featuredProviders);

      if (response.success && response.data != null) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting featured providers: $e');
      return [];
    }
  }

  /// جلب مزود خدمة محدد
  static Future<Map<String, dynamic>?> getProviderById(String providerId) async {
    try {
      final response = await ApiClient.get(ApiUrls.providerById(providerId));

      if (response.success && response.data != null) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting provider by ID: $e');
      return null;
    }
  }

  /// جلب المزودين حسب الخدمة
  static Future<Map<String, dynamic>?> getProvidersByService(String serviceId) async {
    try {
      final response = await ApiClient.get(ApiUrls.providersByService(serviceId));

      if (response.success && response.data != null) {
        return response.data; // يحتوي على service و providers
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting providers by service: $e');
      return null;
    }
  }

  /// جلب المزودين حسب الفئة
  static Future<List<Map<String, dynamic>>> getProvidersByCategory(String categoryId) async {
    try {
      final response = await ApiClient.get(ApiUrls.providersByCategory(categoryId));

      if (response.success && response.data != null) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting providers by category: $e');
      return [];
    }
  }

  /// البحث في المزودين
  static Future<List<Map<String, dynamic>>> searchProviders({
    String? city,
    String? serviceId,
    String? categoryId,
    String? searchTerm,
  }) async {
    try {
      Map<String, dynamic> params = {};
      if (city != null) params['city'] = city;
      if (serviceId != null) params['service_id'] = serviceId;
      if (categoryId != null) params['category_id'] = categoryId;
      if (searchTerm != null) params['search'] = searchTerm;

      final url = ApiUrls.buildSearchUrl(params);
      final response = await ApiClient.get(url);

      if (response.success && response.data != null) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        return [];
      }
    } catch (e) {
      print('Error searching providers: $e');
      return [];
    }
  }

  // ====================
  // Admin Methods (require authentication)
  // ====================

  /// إنشاء فئة جديدة
  static Future<ApiResponse> createCategory(String name) async {
    return await ApiClient.post(ApiUrls.categories, {
      'name': name,
    });
  }

  /// تحديث فئة
  static Future<ApiResponse> updateCategory(String categoryId, String name) async {
    return await ApiClient.put(ApiUrls.categoryById(categoryId), {
      'name': name,
    });
  }

  /// حذف فئة
  static Future<ApiResponse> deleteCategory(String categoryId) async {
    return await ApiClient.delete(ApiUrls.categoryById(categoryId));
  }

  /// إنشاء خدمة جديدة
  static Future<ApiResponse> createService({
    required String categoryId,
    required String name,
  }) async {
    return await ApiClient.post(ApiUrls.services, {
      'category_id': categoryId,
      'name': name,
    });
  }

  /// تحديث خدمة
  static Future<ApiResponse> updateService({
    required String serviceId,
    required String categoryId,
    required String name,
  }) async {
    return await ApiClient.put(ApiUrls.serviceById(serviceId), {
      'category_id': categoryId,
      'name': name,
    });
  }

  /// حذف خدمة
  static Future<ApiResponse> deleteService(String serviceId) async {
    return await ApiClient.delete(ApiUrls.serviceById(serviceId));
  }

  /// تحديث حالة توثيق المزود
  static Future<ApiResponse> updateProviderVerification({
    required String providerId,
    required bool isVerified,
  }) async {
    return await ApiClient.patch(
      ApiUrls.updateProviderVerification(providerId),
      {'is_verified': isVerified},
    );
  }

  /// تحديث حالة المميز للمزود
  static Future<ApiResponse> updateProviderFeatured({
    required String providerId,
    required bool isFeatured,
  }) async {
    return await ApiClient.patch(
      ApiUrls.updateProviderFeatured(providerId),
      {'is_featured': isFeatured},
    );
  }
}