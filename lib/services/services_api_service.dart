// lib/services/services_api_service.dart
import '../core/network/api_client.dart';
import '../core/network/api_urls.dart';
import '../models/category.dart';
import '../models/service.dart';

class ServicesApiService {
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
      return [];
    }
  }

  static Future<Category?> getCategoryById(String categoryId) async {
    try {
      final response = await ApiClient.get(ApiUrls.categoryById(categoryId));

      if (response.success && response.data != null) {
        return Category.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<Service>> getAllServices({
    String? categoryId,
    String? search,
  }) async {
    try {
      final url = ApiUrls.buildServicesUrl(
        categoryId: categoryId,
        search: search,
      );
      final response = await ApiClient.get(url);

      if (response.success && response.data != null) {
        final List<dynamic> data = response.data;
        return data.map((json) => Service.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
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
      return null;
    }
  }

  static Future<List<Service>> getServicesByCategory(String categoryId) async {
    try {
      return await getAllServices(categoryId: categoryId);
    } catch (e) {
      return [];
    }
  }

  static Future<List<Service>> searchServices(String searchTerm) async {
    try {
      return await getAllServices(search: searchTerm);
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getAllProviders({
    String? city,
    String? categoryId,
    String? isVerified,
  }) async {
    try {
      final url = ApiUrls.buildProvidersUrl(
        city: city,
        categoryId: categoryId,
        isVerified: isVerified,
      );
      final response = await ApiClient.get(url);

      if (response.success && response.data != null) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getFeaturedProviders() async {
    try {
      final response = await ApiClient.get(ApiUrls.featuredProviders);

      if (response.success && response.data != null) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getProviderById(String providerId) async {
    try {
      final response = await ApiClient.get(ApiUrls.providerById(providerId));

      if (response.success && response.data != null) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getProvidersByCategory(String categoryId) async {
    try {
      return await getAllProviders(categoryId: categoryId);
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getProvidersByCity(String city) async {
    try {
      return await getAllProviders(city: city);
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getVerifiedProviders() async {
    try {
      return await getAllProviders(isVerified: '1');
    } catch (e) {
      return [];
    }
  }

  static Future<ApiResponse> createCategory(String name) async {
    return await ApiClient.post(ApiUrls.categories, {
      'name': name,
    });
  }

  static Future<ApiResponse> updateCategory(String categoryId, String name) async {
    return await ApiClient.put(ApiUrls.categoryById(categoryId), {
      'name': name,
    });
  }

  static Future<ApiResponse> deleteCategory(String categoryId) async {
    return await ApiClient.delete(ApiUrls.categoryById(categoryId));
  }

  static Future<ApiResponse> createService({
    required String categoryId,
    required String name,
  }) async {
    return await ApiClient.post(ApiUrls.services, {
      'category_id': categoryId,
      'name': name,
    });
  }

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

  static Future<ApiResponse> deleteService(String serviceId) async {
    return await ApiClient.delete(ApiUrls.serviceById(serviceId));
  }

  static Future<ApiResponse> updateProviderVerification({
    required String providerId,
    required bool isVerified,
  }) async {
    return await ApiClient.patch(
      ApiUrls.updateProviderVerification(providerId),
      {'is_verified': isVerified},
    );
  }

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