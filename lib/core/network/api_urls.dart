// lib/core/network/api_urls.dart
class ApiUrls {

  // ====================
  // Auth URLs
  // ====================
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String getUser = '/auth/user';

  // ====================
  // Categories URLs
  // ====================
  static const String categories = '/categories';
  // /categories/{slug}
  // /categories/{categoryId}/services
  // /categories/{categoryId}/providers

  // ====================
  // Provider URLs
  // ====================
  static const String providers = '/providers';
  static const String featuredProviders = '/providers/featured';
  static const String searchProviders = '/providers/search';
  static const String myProfile = '/providers/my/profile';
  static const String updateServices = '/providers/update-services';
  static const String providerStatistics = '/providers/statistics';
  static const String advancedSearch = '/providers/advanced-search';

  // Provider Profile URLs
  static const String providerProfile = '/providers/profile';
  static const String uploadProfileImage = '/upload/profile-image';
  static const String uploadPortfolioImage = '/upload/portfolio-image';

  // /providers/{id}
  // /providers/{id}/rating
  // /providers/{id}/verify
  // /providers/profile/{userId}
  // /services/{serviceId}/providers

  // ====================
  // Helper Methods
  // ====================

  /// بناء رابط Category مع slug
  static String categoryBySlug(String slug) {
    return '/categories/$slug';
  }

  /// بناء رابط Category services
  static String categoryServices(String categoryId) {
    return '/categories/$categoryId/services';
  }

  /// بناء رابط Category providers
  static String categoryProviders(String categoryId) {
    return '/categories/$categoryId/providers';
  }

  /// بناء رابط Provider مع ID
  static String providerById(String id) {
    return '/providers/$id';
  }

  /// بناء رابط Provider profile مع User ID
  static String providerProfileById(String userId) {
    return '/providers/profile/$userId';
  }

  /// بناء رابط Provider rating
  static String providerRating(String providerId) {
    return '/providers/$providerId/rating';
  }

  /// بناء رابط Provider verification
  static String providerVerification(String providerId) {
    return '/providers/$providerId/verify';
  }

  /// بناء رابط Service providers
  static String serviceProviders(String serviceId) {
    return '/services/$serviceId/providers';
  }

  /// بناء رابط مع query parameters
  static String withParams(String baseUrl, Map<String, dynamic> params) {
    if (params.isEmpty) return baseUrl;

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    return '$baseUrl?$queryString';
  }

  /// بناء رابط البحث مع المعاملات
  static String buildSearchUrl(Map<String, dynamic> searchParams) {
    return withParams(searchProviders, searchParams);
  }

  /// بناء رابط البحث المتقدم مع المعاملات
  static String buildAdvancedSearchUrl(Map<String, dynamic> searchParams) {
    return withParams(advancedSearch, searchParams);
  }

  /// بناء رابط الفلترة حسب المدينة
  static String providersByCity(String city) {
    return withParams(providers, {'city': city});
  }

  /// بناء رابط الفلترة حسب نوع الخدمة
  static String providersByServiceType(String serviceType) {
    return withParams(providers, {'service_type': serviceType});
  }

  /// بناء رابط الموثقين فقط
  static String verifiedProviders() {
    return withParams(providers, {'verified': '1'});
  }
}