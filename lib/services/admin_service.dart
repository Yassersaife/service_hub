
import 'package:service_hub/core/network/api_client.dart';

class AdminService {
  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal();

  Future<bool> updateProviderVerification(String providerId, bool isVerified) async {
    try {
      final response = await ApiClient.put('/admin/providers/$providerId/verify', {
        'is_verified': isVerified,
      });
      return response.success;
    } catch (e) {
      print('Error updating provider verification: $e');
      return false;
    }
  }

  Future<bool> updateProviderFeatured(String providerId, bool isFeatured) async {
    try {
      final response = await ApiClient.put('/admin/providers/$providerId/featured', {
        'is_featured': isFeatured,
      });
      return response.success;
    } catch (e) {
      print('Error updating provider featured status: $e');
      return false;
    }
  }


  Future<bool> createServiceCategory(String name, List<String> specialties) async {
    try {
      final response = await ApiClient.post('/admin/categories', {
        'name': name,
        'specialties': specialties,
        'is_active': true,
      });

      return response.success;
    } catch (e) {
      print('Error creating service category: $e');
      return false;
    }
  }

  Future<bool> deleteServiceCategory(int categoryId) async {
    try {
      final response = await ApiClient.delete('/admin/categories/$categoryId');
      return response.success;
    } catch (e) {
      print('Error deleting service category: $e');
      return false;
    }
  }

  }