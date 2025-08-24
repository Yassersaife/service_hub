// lib/features/service_provider/services/provider_service.dart
import '../models/provider_profile.dart';

class ProviderService {
  static final ProviderService _instance = ProviderService._internal();
  factory ProviderService() => _instance;
  ProviderService._internal();

  final Map<String, ProviderProfile> _profiles = {};

  // الحصول على الملف الشخصي
  Future<ProviderProfile?> getProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _profiles[userId];
  }

  // إنشاء أو تحديث الملف الشخصي
  Future<bool> saveProfile(ProviderProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 800));
    _profiles[profile.userId] = profile;
    return true;
  }

  // حذف الملف الشخصي
  Future<bool> deleteProfile(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _profiles.remove(userId);
    return true;
  }

  // الحصول على جميع مقدمي الخدمات
  Future<List<ProviderProfile>> getAllProviders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _profiles.values.where((p) => p.isComplete).toList();
  }

  // البحث عن مقدمي الخدمات
  Future<List<ProviderProfile>> searchProviders({
    String? query,
    String? serviceType,
    String? city,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var results = _profiles.values.where((p) => p.isComplete);

    if (query != null && query.isNotEmpty) {
      results = results.where((p) =>
      p.getServiceLabel().toLowerCase().contains(query.toLowerCase()) ||
          p.city.toLowerCase().contains(query.toLowerCase()) ||
          p.description?.toLowerCase().contains(query.toLowerCase()) == true
      );
    }

    if (serviceType != null) {
      results = results.where((p) => p.serviceType == serviceType);
    }

    if (city != null) {
      results = results.where((p) => p.city == city);
    }

    return results.toList();
  }

  // الحصول على مقدمي الخدمات حسب النوع
  Future<List<ProviderProfile>> getProvidersByType(String serviceType) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _profiles.values
        .where((p) => p.isComplete && p.serviceType == serviceType)
        .toList();
  }

  // الحصول على مقدمي الخدمات حسب المدينة
  Future<List<ProviderProfile>> getProvidersByCity(String city) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _profiles.values
        .where((p) => p.isComplete && p.city == city)
        .toList();
  }

  // الحصول على أفضل مقدمي الخدمات
  Future<List<ProviderProfile>> getTopRatedProviders({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final providers = _profiles.values.where((p) => p.isComplete).toList();
    providers.sort((a, b) => b.rating.compareTo(a.rating));
    return providers.take(limit).toList();
  }

  // الحصول على مقدمي الخدمات الموثقين
  Future<List<ProviderProfile>> getVerifiedProviders() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _profiles.values
        .where((p) => p.isComplete && p.isVerified)
        .toList();
  }

  // إضافة تقييم لمقدم خدمة
  Future<bool> addRating(String userId, double rating) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final profile = _profiles[userId];
    if (profile == null) return false;

    // حساب التقييم الجديد
    final totalRating = (profile.rating * profile.reviewsCount) + rating;
    final newReviewsCount = profile.reviewsCount + 1;
    final newRating = totalRating / newReviewsCount;

    // تحديث الملف الشخصي
    final updatedProfile = profile.copyWith(
      rating: double.parse(newRating.toStringAsFixed(1)),
      reviewsCount: newReviewsCount,
    );

    _profiles[userId] = updatedProfile;
    return true;
  }

  // تحديث حالة التوثيق
  Future<bool> updateVerificationStatus(String userId, bool isVerified) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final profile = _profiles[userId];
    if (profile == null) return false;

    final updatedProfile = profile.copyWith(isVerified: isVerified);
    _profiles[userId] = updatedProfile;
    return true;
  }

  // الحصول على إحصائيات عامة
  Future<Map<String, dynamic>> getStatistics() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final allProfiles = _profiles.values.where((p) => p.isComplete).toList();
    final verifiedCount = allProfiles.where((p) => p.isVerified).length;

    // حساب التقييم المتوسط
    final totalRating = allProfiles.fold<double>(0, (sum, p) => sum + p.rating);
    final averageRating = allProfiles.isNotEmpty ? totalRating / allProfiles.length : 0.0;

    // حساب توزيع الخدمات
    final serviceDistribution = <String, int>{};
    for (final profile in allProfiles) {
      serviceDistribution[profile.serviceType] =
          (serviceDistribution[profile.serviceType] ?? 0) + 1;
    }

    return {
      'totalProviders': allProfiles.length,
      'verifiedProviders': verifiedCount,
      'averageRating': double.parse(averageRating.toStringAsFixed(1)),
      'serviceDistribution': serviceDistribution,
      'topService': serviceDistribution.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key,
    };
  }

  // تصفية متقدمة
  Future<List<ProviderProfile>> advancedSearch({
    String? query,
    String? serviceType,
    String? city,
    double? minRating,
    bool? isVerified,
    String? sortBy, // 'rating', 'name', 'date', 'reviewsCount'
    bool ascending = true,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    var results = _profiles.values.where((p) => p.isComplete);

    // تطبيق الفلاتر
    if (query != null && query.isNotEmpty) {
      results = results.where((p) =>
      p.getServiceLabel().toLowerCase().contains(query.toLowerCase()) ||
          p.city.toLowerCase().contains(query.toLowerCase()) ||
          p.description?.toLowerCase().contains(query.toLowerCase()) == true ||
          p.specialties.any((s) => s.toLowerCase().contains(query.toLowerCase()))
      );
    }

    if (serviceType != null) {
      results = results.where((p) => p.serviceType == serviceType);
    }

    if (city != null) {
      results = results.where((p) => p.city == city);
    }

    if (minRating != null) {
      results = results.where((p) => p.rating >= minRating);
    }

    if (isVerified != null) {
      results = results.where((p) => p.isVerified == isVerified);
    }

    // تحويل إلى قائمة للترتيب
    final resultsList = results.toList();

    // تطبيق الترتيب
    if (sortBy != null) {
      resultsList.sort((a, b) {
        int comparison = 0;
        switch (sortBy) {
          case 'rating':
            comparison = a.rating.compareTo(b.rating);
            break;
          case 'reviewsCount':
            comparison = a.reviewsCount.compareTo(b.reviewsCount);
            break;
          case 'date':
            comparison = a.joinDate.compareTo(b.joinDate);
            break;
          case 'name':
          default:
          // يحتاج access للـ User name - سنتركه فارغ حالياً
            comparison = 0;
            break;
        }
        return ascending ? comparison : -comparison;
      });
    }

    return resultsList;
  }

  // إضافة بعض البيانات التجريبية المحسنة
  void initializeDummyData() {
    final dummyProfiles = [
      ProviderProfile(
        userId: '1',
        name: 'ياسر صيفي',
        serviceType: 'photographer',
        city: 'نابلس',
        description: 'مصور محترف متخصص في التصوير الفوتوغرافي والأعراس والمناسبات الخاصة. أعمل في هذا المجال منذ أكثر من 8 سنوات وأمتلك خبرة واسعة في التعامل مع العملاء وتقديم أفضل النتائج. أستخدم أحدث المعدات والتقنيات للحصول على صور عالية الجودة.',
        profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300',
        portfolioImages: [
          'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400',
          'https://images.unsplash.com/photo-1519741497674-611481863552?w=400',
          'https://images.unsplash.com/photo-1520637836862-4d197d17c7a4?w=400',
          'https://images.unsplash.com/photo-1606216794074-735e91aa2c92?w=400',
          'https://images.unsplash.com/photo-1582623505956-9100b5c46d1d?w=400',
          'https://images.unsplash.com/photo-1545558014-8692077e9b5c?w=400',
        ],
        rating: 4.8,
        reviewsCount: 47,
        workHours: 'السبت - الخميس: 9 صباحاً - 10 مساءً',
        isVerified: true,
        specialties: ['تصوير أعراس', 'تصوير مناسبات', 'تصوير بورتريه', 'التصوير الإبداعي'],
        socialMedia: {
          'facebook': 'https://facebook.com/ahmed.photographer',
          'instagram': 'https://instagram.com/ahmed_photography',
        },
        joinDate: DateTime.now().subtract(const Duration(days: 2920)),
        isComplete: true,
      ),

      ProviderProfile(
        userId: '2',
        name: 'لين قدومي',
        serviceType: 'video-editor',
        city: 'طولكرم',
        description: 'متخصصة في مونتاج الفيديوهات والأفلام القصيرة والإعلانات التجارية. أقدم خدمات احترافية في المونتاج والموشن جرافيك والتأثيرات البصرية. أعمل مع برامج Adobe Premier Pro وAfter Effects وDaVinci Resolve.',
        profileImage: 'https://images.unsplash.com/photo-1494790108755-2616b612b4f1?w=300',
        portfolioImages: [
          'https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?w=400',
          'https://images.unsplash.com/photo-1574717025058-2f4e2c5a5c7b?w=400',
          'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=400',
          'https://images.unsplash.com/photo-1598300042247-d088f8ab3a91?w=400',
        ],
        rating: 4.6,
        reviewsCount: 32,
        workHours: 'الأحد - الخميس: 10 صباحاً - 8 مساءً',
        isVerified: true,
        specialties: ['مونتاج أفلام', 'إعلانات تجارية', 'موشن جرافيك', 'تحرير فيديو'],
        socialMedia: {
          'instagram': 'https://instagram.com/sara_videoeditor',
          'linkedin': 'https://linkedin.com/in/sara-videoeditor',
        },
        joinDate: DateTime.now().subtract(const Duration(days: 1825)),
        isComplete: true,
      ),

      ProviderProfile(
        userId: '3',
        name: 'براء',
        serviceType: 'photo-editor',
        city: 'رام الله',
        description: 'خبير في تعديل وتحسين الصور باستخدام أحدث التقنيات والبرامج الاحترافية. أقدم خدمات الريتوش والتلوين والتصحيح والتصميم الجرافيكي. متخصص في Photoshop وLightroom وCapture One.',
        profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=300',
        portfolioImages: [
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
          'https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=400',
          'https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?w=400',
          'https://images.unsplash.com/photo-1561736778-92e52a7769ef?w=400',
        ],
        rating: 4.9,
        reviewsCount: 28,
        workHours: 'يومياً: 2 مساءً - 11 مساءً',
        isVerified: false,
        specialties: ['ريتوش الصور', 'تصحيح الألوان', 'التصميم الجرافيكي', 'معالجة RAW'],
        socialMedia: {
          'facebook': 'https://facebook.com/khalil.editor',
          'instagram': 'https://instagram.com/khalil_designs',
        },
        joinDate: DateTime.now().subtract(const Duration(days: 1095)),
        isComplete: true,
      ),

      ProviderProfile(
        userId: '4',
        name: 'حفص عبوشي',
        serviceType: 'printer',
        address:'الخليل -دورة',
        city: 'الخليل',
        description: 'مطبعة متخصصة في طباعة الصور بجودة عالية وأحجام مختلفة. نوفر خدمات الطباعة على مواد متنوعة وبأسعار منافسة. نستخدم طابعات Canon وEpson الاحترافية لضمان أفضل جودة.',
        profileImage: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=300',
        portfolioImages: [
          'https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=400',
          'https://images.unsplash.com/photo-1595465706152-0cf9d9ed3d84?w=400',
          'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=400',
        ],
        rating: 4.4,
        reviewsCount: 15,
        workHours: 'السبت - الخميس: 8 صباحاً - 6 مساءً',
        isVerified: true,
        specialties: ['طباعة صور فوتوغرافية', 'طباعة على القماش', 'طباعة بانوراما', 'طباعة معدنية'],
        socialMedia: {
          'facebook': 'https://facebook.com/alquds.printing',
        },
        joinDate: DateTime.now().subtract(const Duration(days: 730)),
        isComplete: true,
      ),
    ];

    for (var profile in dummyProfiles) {
      _profiles[profile.userId] = profile;
    }
  }
}