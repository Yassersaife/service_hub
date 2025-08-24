import '../core/network/api_client.dart';
import '../core/network/api_urls.dart';
import '../models/service_models.dart';

class ServicesApiService {

  /// جلب جميع فئات الخدمات
  static Future<List<ServiceCategory>> getAllServiceCategories() async {
    final response = await ApiClient.get('/categories');

    if (response.success) {
      final List<dynamic> data = response.data;
      return data.map((json) => ServiceCategory.fromJson(json)).toList();
    } else {
      throw Exception(response.message);
    }
  }

  /// جلب فئة خدمة محددة
  static Future<ServiceCategory> getServiceCategoryById(String categoryId) async {
    final response = await ApiClient.get('/categories/$categoryId');

    if (response.success) {
      return ServiceCategory.fromJson(response.data);
    } else {
      throw Exception(response.message);
    }
  }

  /// جلب فئة خدمة محددة بالـ slug
  static Future<ServiceCategory> getServiceCategoryBySlug(String slug) async {
    final response = await ApiClient.get(ApiUrls.categoryBySlug(slug));

    if (response.success) {
      return ServiceCategory.fromJson(response.data);
    } else {
      throw Exception(response.message);
    }
  }

  /// جلب خدمات فئة معينة
  static Future<List<Service>> getCategoryServices(String categoryId) async {
    final response = await ApiClient.get(ApiUrls.categoryServices(categoryId));

    if (response.success) {
      final List<dynamic> servicesData = response.data;
      return servicesData.map((json) => Service.fromJson(json)).toList();
    } else {
      throw Exception(response.message);
    }
  }

  /// جلب مقدمي الخدمة لفئة معينة
  static Future<List<Map<String, dynamic>>> getCategoryProviders(String categoryId) async {
    final response = await ApiClient.get(ApiUrls.categoryProviders(categoryId));

    if (response.success) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception(response.message);
    }
  }

  /// جلب مقدمي الخدمة لخدمة معينة
  static Future<List<Map<String, dynamic>>> getProvidersByService(String serviceId) async {
    final response = await ApiClient.get(ApiUrls.serviceProviders(serviceId));

    if (response.success) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception(response.message);
    }
  }

  /// جلب مقدمي الخدمات المميزين
  static Future<List<Map<String, dynamic>>> getFeaturedProviders() async {
    final response = await ApiClient.get(ApiUrls.featuredProviders);

    if (response.success) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception(response.message);
    }
  }

  /// جلب جميع مقدمي الخدمات
  static Future<List<Map<String, dynamic>>> getAllProviders() async {
    final response = await ApiClient.get(ApiUrls.providers);

    if (response.success) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception(response.message);
    }
  }

  /// جلب مقدم خدمة محدد
  static Future<Map<String, dynamic>> getProviderById(String providerId) async {
    final response = await ApiClient.get(ApiUrls.providerById(providerId));

    if (response.success) {
      return response.data;
    } else {
      throw Exception(response.message);
    }
  }

  /// البحث في مقدمي الخدمات
  static Future<List<Map<String, dynamic>>> searchProviders({
    required String query,
    String? serviceType,
    String? city,
    String? categoryId,
  }) async {

    final params = <String, dynamic>{'q': query};

    if (serviceType != null) params['service_type'] = serviceType;
    if (city != null) params['city'] = city;
    if (categoryId != null) params['category_id'] = categoryId;

    final searchUrl = ApiUrls.withParams(ApiUrls.searchProviders, params);
    final response = await ApiClient.get(searchUrl);

    if (response.success) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      throw Exception(response.message);
    }
  }
}