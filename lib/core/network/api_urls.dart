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
  static const String newProviders = '/providers/new';

  static const String myProvider = '/my-profile';

  // ====================
  // Portfolio Images URLs
  // ====================
  static String deletePortfolioImage(String imageId) {
    return '/portfolio-images/$imageId';
  }

  // ====================
  // Settings URLs
  // ====================
  static const String settings = '/settings';

  // ====================
  // Helper Methods
  // ====================

  static String categoryById(String id) {
    return '/categories/$id';
  }

  static String serviceById(String id) {
    return '/services/$id';
  }

  static String providerById(String id) {
    return '/providers/$id';
  }

  static String updateProviderVerification(String providerId) {
    return '/providers/$providerId/verify';
  }

  static String updateProviderFeatured(String providerId) {
    return '/providers/$providerId/feature';
  }
  static String servicesByCategory(String categoryId) {
    return '/categories/$categoryId/services';
  }

  static String withParams(String baseUrl, Map<String, dynamic> params) {
    if (params.isEmpty) return baseUrl;

    final queryString = params.entries
        .where((e) => e.value != null && e.value.toString().isNotEmpty)
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    return queryString.isEmpty ? baseUrl : '$baseUrl?$queryString';
  }

  static String buildProvidersUrl({
    String? city,
    String? categoryId,
    String? isVerified,
  }) {
    Map<String, dynamic> params = {};
    if (city != null) params['city'] = city;
    if (categoryId != null) params['category_id'] = categoryId;
    if (isVerified != null) params['is_verified'] = isVerified;
    return withParams(providers, params);
  }

  static String buildServicesUrl({String? categoryId, String? search}) {
    Map<String, dynamic> params = {};
    if (categoryId != null) params['category_id'] = categoryId;
    if (search != null) params['search'] = search;
    return withParams(services, params);
  }

  static String providersByCity(String city) {
    return buildProvidersUrl(city: city);
  }

  static String providersByCategory(String categoryId) {
    return buildProvidersUrl(categoryId: categoryId);
  }

  static String verifiedProviders() {
    return buildProvidersUrl(isVerified: '1');
  }

  static String providersByCityAndCategory(String city, String categoryId) {
    return buildProvidersUrl(city: city, categoryId: categoryId);
  }
}