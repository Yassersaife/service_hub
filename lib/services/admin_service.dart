// lib/services/admin_service.dart - النسخة المحدثة
import 'package:service_hub/core/network/api_client.dart';
import 'package:service_hub/core/network/api_urls.dart';

class AdminService {
  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal();

  // ====================
  // Provider Management
  // ====================

  Future<bool> updateProviderVerification(String providerId, bool isVerified) async {
    try {
      final response = await ApiClient.patch(
        ApiUrls.updateProviderVerification(providerId),
        {'is_verified': isVerified},
      );
      return response.success;
    } catch (e) {
      print('Error updating provider verification: $e');
      return false;
    }
  }

  Future<bool> updateProviderFeatured(String providerId, bool isFeatured) async {
    try {
      final response = await ApiClient.patch(
        ApiUrls.updateProviderFeatured(providerId),
        {'is_featured': isFeatured},
      );
      return response.success;
    } catch (e) {
      print('Error updating provider featured status: $e');
      return false;
    }
  }

  // ====================
  // Category Management
  // ====================

  Future<bool> createServiceCategory(String name) async {
    try {
      final response = await ApiClient.post(ApiUrls.categories, {
        'name': name,
      });
      return response.success;
    } catch (e) {
      print('Error creating service category: $e');
      return false;
    }
  }

  Future<bool> updateServiceCategory(String categoryId, String name) async {
    try {
      final response = await ApiClient.put(
        ApiUrls.categoryById(categoryId),
        {'name': name},
      );
      return response.success;
    } catch (e) {
      print('Error updating service category: $e');
      return false;
    }
  }

  Future<bool> deleteServiceCategory(String categoryId) async {
    try {
      final response = await ApiClient.delete(ApiUrls.categoryById(categoryId));
      return response.success;
    } catch (e) {
      print('Error deleting service category: $e');
      return false;
    }
  }

  // ====================
  // Service Management
  // ====================

  Future<bool> createService({
    required String categoryId,
    required String name,
  }) async {
    try {
      final response = await ApiClient.post(ApiUrls.services, {
        'category_id': categoryId,
        'name': name,
      });
      return response.success;
    } catch (e) {
      print('Error creating service: $e');
      return false;
    }
  }

  Future<bool> updateService({
    required String serviceId,
    required String categoryId,
    required String name,
  }) async {
    try {
      final response = await ApiClient.put(
        ApiUrls.serviceById(serviceId),
        {
          'category_id': categoryId,
          'name': name,
        },
      );
      return response.success;
    } catch (e) {
      print('Error updating service: $e');
      return false;
    }
  }

  Future<bool> deleteService(String serviceId) async {
    try {
      final response = await ApiClient.delete(ApiUrls.serviceById(serviceId));
      return response.success;
    } catch (e) {
      print('Error deleting service: $e');
      return false;
    }
  }

  Future<Map<String, bool>> batchUpdateProviders({
    List<String>? verifyProviders,
    List<String>? unverifyProviders,
    List<String>? featureProviders,
    List<String>? unfeatureProviders,
  }) async {
    Map<String, bool> results = {};

    // Update verification status
    if (verifyProviders != null) {
      for (String providerId in verifyProviders) {
        results['verify_$providerId'] = await updateProviderVerification(providerId, true);
      }
    }

    if (unverifyProviders != null) {
      for (String providerId in unverifyProviders) {
        results['unverify_$providerId'] = await updateProviderVerification(providerId, false);
      }
    }

    // Update featured status
    if (featureProviders != null) {
      for (String providerId in featureProviders) {
        results['feature_$providerId'] = await updateProviderFeatured(providerId, true);
      }
    }

    if (unfeatureProviders != null) {
      for (String providerId in unfeatureProviders) {
        results['unfeature_$providerId'] = await updateProviderFeatured(providerId, false);
      }
    }

    return results;
  }
}