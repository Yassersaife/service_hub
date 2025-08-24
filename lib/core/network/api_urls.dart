// lib/core/network/api_urls.dart
class ApiUrls {

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
  // /providers/{id}
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
}