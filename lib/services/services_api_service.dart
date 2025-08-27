// lib/services/services_api_service.dart
import '../core/network/api_client.dart';
import '../core/network/api_urls.dart';
import '../models/service_models.dart';

class ServicesApiService {
  /// جلب جميع فئات الخدمات
  static Future<List<ServiceCategory>> getAllServiceCategories() async {
    try {
      final response = await ApiClient.get('/categories');

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data;
        return data.map((json) => ServiceCategory.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting categories from API: $e');
      return [];
    }
  }

  /// جلب جميع الخدمات (مسطحة)
  static Future<List<Service>> getAllServices() async {
    try {
      final response = await ApiClient.get('/categories');

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

  /// جلب الخدمات حسب الفئة
  static Future<List<Service>> getServicesByCategory(String categoryId) async {
    try {
      final response = await ApiClient.get('/categories/$categoryId/services');

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data;
        return data.map((json) => Service.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting services by category: $e');
      return [];
    }
  }

  /// جلب التخصصات المتاحة لخدمة معينة
  static Future<List<String>> getSpecialtiesByService(String serviceSlug) async {
    try {
      final response = await ApiClient.get('/categories/$serviceSlug');

      if (response.success && response.data != null) {
        return List<String>.from(response.data);
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting specialties: $e');
      return [];
    }
  }

  /// جلب فئة خدمة محددة
  static Future<ServiceCategory?> getServiceCategoryById(String categoryId) async {
    try {
      final response = await ApiClient.get('/categories/$categoryId');

      if (response.success && response.data != null) {
        return ServiceCategory.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting category by ID: $e');
      return null;
    }
  }

  /// جلب فئة خدمة محددة بالـ slug
  static Future<ServiceCategory?> getServiceCategoryBySlug(String slug) async {
    try {
      final response = await ApiClient.get(ApiUrls.categoryBySlug(slug));

      if (response.success && response.data != null) {
        return ServiceCategory.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting category by slug: $e');
      return null;
    }
  }

  /// جلب خدمات فئة معينة
  static Future<List<Service>> getCategoryServices(String categoryId) async {
    try {
      final response = await ApiClient.get(ApiUrls.categoryServices(categoryId));

      if (response.success && response.data != null) {
        final List<dynamic> servicesData = response.data;
        return servicesData.map((json) => Service.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting category services: $e');
      return [];
    }
  }

  /// جلب مقدمي الخدمة لفئة معينة
  static Future<List<Map<String, dynamic>>> getCategoryProviders(String categoryId) async {
    try {
      final response = await ApiClient.get(ApiUrls.categoryProviders(categoryId));

      if (response.success && response.data != null) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting category providers: $e');
      return [];
    }
  }

  /// جلب مقدمي الخدمة لخدمة معينة
  static Future<List<Map<String, dynamic>>> getProvidersByService(String serviceId) async {
    try {
      final response = await ApiClient.get(ApiUrls.serviceProviders(serviceId));

      if (response.success && response.data != null) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        return [];
      }
    } catch (e) {
      print('Error getting providers by service: $e');
      return [];
    }
  }

  /// جلب مقدمي الخدمات المميزين
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
      print('Error getting all providers: $e');
      return [];
    }
  }

  /// جلب مقدم خدمة محدد
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

  /// البحث في مقدمي الخدمات
  static Future<List<Map<String, dynamic>>> searchProviders({
    required String query,
    String? serviceType,
    String? city,
    String? categoryId,
  }) async {
    try {
      final params = <String, dynamic>{'q': query};

      if (serviceType != null) params['service_type'] = serviceType;
      if (city != null) params['city'] = city;
      if (categoryId != null) params['category_id'] = categoryId;

      final searchUrl = ApiUrls.withParams(ApiUrls.searchProviders, params);
      final response = await ApiClient.get(searchUrl);

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
}
