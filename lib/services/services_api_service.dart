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
        // في حالة عدم توفر الـ API، إرجاع بيانات وهمية
        return _getDummyCategories();
      }
    } catch (e) {
      print('Error getting categories from API: $e');
      // في حالة حدوث خطأ، إرجاع بيانات وهمية
      return _getDummyCategories();
    }
  }

  /// جلب فئة خدمة محددة
  static Future<ServiceCategory> getServiceCategoryById(String categoryId) async {
    try {
      final response = await ApiClient.get('/categories/$categoryId');

      if (response.success && response.data != null) {
        return ServiceCategory.fromJson(response.data);
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('Error getting category by ID: $e');
      // إرجاع فئة افتراضية في حالة الخطأ
      final categories = _getDummyCategories();
      return categories.firstWhere(
            (cat) => cat.id.toString() == categoryId,
        orElse: () => categories.first,
      );
    }
  }

  /// جلب فئة خدمة محددة بالـ slug
  static Future<ServiceCategory> getServiceCategoryBySlug(String slug) async {
    try {
      final response = await ApiClient.get(ApiUrls.categoryBySlug(slug));

      if (response.success && response.data != null) {
        return ServiceCategory.fromJson(response.data);
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('Error getting category by slug: $e');
      final categories = _getDummyCategories();
      return categories.firstWhere(
            (cat) => cat.slug == slug,
        orElse: () => categories.first,
      );
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
        throw Exception(response.message);
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
        throw Exception(response.message);
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
        throw Exception(response.message);
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
        throw Exception(response.message);
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
        throw Exception(response.message);
      }
    } catch (e) {
      print('Error getting all providers: $e');
      return [];
    }
  }

  /// جلب مقدم خدمة محدد
  static Future<Map<String, dynamic>> getProviderById(String providerId) async {
    try {
      final response = await ApiClient.get(ApiUrls.providerById(providerId));

      if (response.success && response.data != null) {
        return response.data;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      print('Error getting provider by ID: $e');
      throw Exception('Provider not found');
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
        throw Exception(response.message);
      }
    } catch (e) {
      print('Error searching providers: $e');
      return [];
    }
  }

  // ===== بيانات وهمية للفئات =====
  static List<ServiceCategory> _getDummyCategories() {
    return [
      ServiceCategory(
        id: 1,
        name: 'التصوير والإنتاج',
        nameEn: 'Photography & Production',
        slug: 'photography-production',
        icon: 'camera',
        color: '#3B82F6',
        gradientColors: ['#3B82F6', '#1E40AF'],
        description: 'خدمات التصوير الفوتوغرافي وإنتاج الفيديوهات',
        isActive: true,
        sortOrder: 1,
        services: [
          Service(
            id: 1,
            name: 'تصوير المناسبات',
            nameEn: 'Event Photography',
            slug: 'event-photography',
            description: 'تصوير الأعراس والمناسبات الخاصة',
            isActive: true,
            sortOrder: 1,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Service(
            id: 2,
            name: 'تصوير المنتجات',
            nameEn: 'Product Photography',
            slug: 'product-photography',
            description: 'تصوير المنتجات للمتاجر والإعلانات',
            isActive: true,
            sortOrder: 2,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Service(
            id: 3,
            name: 'تصوير البورتريه',
            nameEn: 'Portrait Photography',
            slug: 'portrait-photography',
            description: 'تصوير شخصي احترافي',
            isActive: true,
            sortOrder: 3,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
        servicesCount: 3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      ServiceCategory(
        id: 2,
        name: 'التصميم والجرافيك',
        nameEn: 'Design & Graphics',
        slug: 'design-graphics',
        icon: 'palette',
        color: '#10B981',
        gradientColors: ['#10B981', '#059669'],
        description: 'خدمات التصميم الجرافيكي والهوية البصرية',
        isActive: true,
        sortOrder: 2,
        services: [
          Service(
            id: 4,
            name: 'تصميم الشعارات',
            nameEn: 'Logo Design',
            slug: 'logo-design',
            description: 'تصميم شعارات مميزة للشركات والأفراد',
            isActive: true,
            sortOrder: 1,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Service(
            id: 5,
            name: 'تصميم وسائل التواصل',
            nameEn: 'Social Media Design',
            slug: 'social-media-design',
            description: 'تصميمات لوسائل التواصل الاجتماعي',
            isActive: true,
            sortOrder: 2,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Service(
            id: 6,
            name: 'الهوية البصرية',
            nameEn: 'Brand Identity',
            slug: 'brand-identity',
            description: 'تصميم الهوية البصرية الكاملة',
            isActive: true,
            sortOrder: 3,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
        servicesCount: 3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      ServiceCategory(
        id: 3,
        name: 'المطابع والمكاتب',
        nameEn: 'Printing & Office',
        slug: 'printing-office',
        icon: 'print',
        color: '#8B5CF6',
        gradientColors: ['#8B5CF6', '#7C3AED'],
        description: 'خدمات الطباعة والتجليد والخدمات المكتبية',
        isActive: true,
        sortOrder: 3,
        services: [
          Service(
            id: 7,
            name: 'طباعة الصور',
            nameEn: 'Photo Printing',
            slug: 'photo-printing',
            description: 'طباعة الصور بجودة عالية',
            isActive: true,
            sortOrder: 1,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Service(
            id: 8,
            name: 'طباعة البوسترات',
            nameEn: 'Poster Printing',
            slug: 'poster-printing',
            description: 'طباعة البوسترات والإعلانات',
            isActive: true,
            sortOrder: 2,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Service(
            id: 9,
            name: 'طباعة مخصصة',
            nameEn: 'Custom Printing',
            slug: 'custom-printing',
            description: 'طباعة على المواد المختلفة',
            isActive: true,
            sortOrder: 3,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
        servicesCount: 3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      ServiceCategory(
        id: 4,
        name: 'الخدمات الرقمية',
        nameEn: 'Digital Services',
        slug: 'digital-services',
        icon: 'computer',
        color: '#F59E0B',
        gradientColors: ['#F59E0B', '#D97706'],
        description: 'خدمات المونتاج وتحرير الصور والفيديوهات',
        isActive: true,
        sortOrder: 4,
        services: [
          Service(
            id: 10,
            name: 'مونتاج الفيديو',
            nameEn: 'Video Editing',
            slug: 'video-editing',
            description: 'مونتاج وتحرير الفيديوهات الاحترافي',
            isActive: true,
            sortOrder: 1,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Service(
            id: 11,
            name: 'تحرير الصور',
            nameEn: 'Photo Editing',
            slug: 'photo-editing',
            description: 'تحرير وتعديل الصور باحترافية',
            isActive: true,
            sortOrder: 2,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Service(
            id: 12,
            name: 'تصميم المواقع',
            nameEn: 'Website Design',
            slug: 'website-design',
            description: 'تصميم وتطوير المواقع الإلكترونية',
            isActive: true,
            sortOrder: 3,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
        servicesCount: 3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}