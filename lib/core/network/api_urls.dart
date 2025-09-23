// lib/core/network/api_urls.dart
class ApiUrls {

  // ====================
  // Auth URLs
  // ====================
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String getUser = '/auth/user';
  static const String deleteAccount = '/auth/account';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyResetToken = '/auth/verify-reset-token';
  static const String resetPassword = '/auth/reset-password';
  // ====================
  // Categories URLs
  // ====================
  static const String categories = '/categories';

  // ====================
  // Services URLs
  // ====================
  static const String services = '/services';

  // ====================
  // Provider URLs
  // ====================
  static const String providers = '/providers';
  static const String featuredProviders = '/providers/featured';
  static const String searchProviders = '/providers/search';

  // ====================
  // Settings URLs
  // ====================
  static const String settings = '/settings';
  // ====================
  // Helper Methods
  // ====================

  /// بناء رابط Category مع ID
  static String categoryById(String id) {
    return '/categories/$id';
  }

  /// بناء رابط Service مع ID
  static String serviceById(String id) {
    return '/services/$id';
  }

  /// بناء رابط Provider مع ID
  static String providerById(String id) {
    return '/providers/$id';
  }

  /// بناء رابط المزودين حسب الخدمة
  static String providersByService(String serviceId) {
    return '/providers/service/$serviceId';
  }

  /// بناء رابط المزودين حسب الفئة
  static String providersByCategory(String categoryId) {
    return '/providers/category/$categoryId';
  }

  /// بناء رابط تحديث حالة التوثيق (admin only)
  static String updateProviderVerification(String providerId) {
    return '/providers/$providerId/verification';
  }

  /// بناء رابط تحديث حالة المميز (admin only)
  static String updateProviderFeatured(String providerId) {
    return '/providers/$providerId/featured';
  }

  /// بناء رابط مع query parameters
  static String withParams(String baseUrl, Map<String, dynamic> params) {
    if (params.isEmpty) return baseUrl;

    final queryString = params.entries
        .where((e) => e.value != null && e.value.toString().isNotEmpty)
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    return queryString.isEmpty ? baseUrl : '$baseUrl?$queryString';
  }

  /// بناء رابط البحث مع المعاملات
  static String buildSearchUrl(Map<String, dynamic> searchParams) {
    return withParams(searchProviders, searchParams);
  }

  /// بناء رابط الخدمات مع فلترة
  static String buildServicesUrl({String? categoryId, String? search}) {
    Map<String, dynamic> params = {};
    if (categoryId != null) params['category_id'] = categoryId;
    if (search != null) params['search'] = search;
    return withParams(services, params);
  }

  /// بناء رابط البحث في المزودين حسب المدينة
  static String providersByCity(String city) {
    return buildSearchUrl({'city': city});
  }

  /// بناء رابط البحث في المزودين حسب الخدمة
  static String providersSearchByService(String serviceId) {
    return buildSearchUrl({'service_id': serviceId});
  }

  /// بناء رابط البحث في المزودين حسب الفئة
  static String providersSearchByCategory(String categoryId) {
    return buildSearchUrl({'category_id': categoryId});
  }

  /// بناء رابط البحث العام في المزودين
  static String providersGeneralSearch(String searchTerm) {
    return buildSearchUrl({'search': searchTerm});
  }
}