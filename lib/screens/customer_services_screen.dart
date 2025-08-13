import 'package:flutter/material.dart';
import '../models/service_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/service_provider_card.dart';
import '../widgets/search_filters.dart';

class CustomerServicesScreen extends StatefulWidget {
  const CustomerServicesScreen({super.key});

  @override
  State<CustomerServicesScreen> createState() => _CustomerServicesScreenState();
}

class _CustomerServicesScreenState extends State<CustomerServicesScreen> {
  // بيانات تجريبية محدثة3
  List<ServiceProvider> allProviders = [
    ServiceProvider(
      name: 'أحمد محمد الصوراني',
      service: 'photographer',
      city: 'نابلس',
      phone: '0599123456',
      email: 'ahmed.photographer@example.com',
      description: 'مصور محترف متخصص في التصوير الفوتوغرافي والأعراس والمناسبات الخاصة. أعمل في هذا المجال منذ أكثر من 8 سنوات وقد صورت أكثر من 200 عرس.',
      profileImage: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300',
      portfolioImages: [
        'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400',
        'https://images.unsplash.com/photo-1519741497674-611481863552?w=400',
        'https://images.unsplash.com/photo-1520637836862-4d197d17c7a4?w=400',
        'https://images.unsplash.com/photo-1529636798458-92182e662485?w=400',
        'https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=400',
      ],
      rating: 4.8,
      reviewsCount: 47,
      workHours: 'السبت - الخميس: 9 صباحاً - 10 مساءً',
      isVerified: true,
      specialties: ['تصوير أعراس', 'تصوير مناسبات', 'تصوير بورتريه', 'تصوير منتجات'],
      socialMedia: {
        'facebook': 'https://facebook.com/ahmed.photographer',
        'instagram': 'https://instagram.com/ahmed_photography',
      },
      joinDate: DateTime.now().subtract(const Duration(days: 2920)), // 8 سنوات
    ),
    ServiceProvider(
      name: 'لين القدومي',
      service: 'video-editor',
      city: 'طولكرم',
      phone: '059987999',
      email: 'leen@example.com',
      description: 'متخصصة في مونتاج الفيديوهات والأفلام القصيرة والإعلانات التجارية. خبرة 5 سنوات في استخدام برامج المونتاج المتقدمة.',
      profileImage: 'https://images.unsplash.com/photo-1494790108755-2616b612b4f1?w=300',
      portfolioImages: [
        'https://images.unsplash.com/photo-1574717024653-61fd2cf4d44d?w=400',
        'https://images.unsplash.com/photo-1574717025058-2f4e2c5a5c7b?w=400',
        'https://images.unsplash.com/photo-1574717025394-e5c3e8a5c5f7?w=400',
      ],
      rating: 4.6,
      reviewsCount: 32,
      workHours: 'الأحد - الخميس: 10 صباحاً - 8 مساءً',
      isVerified: true,
      specialties: ['مونتاج أفلام', 'إعلانات تجارية', 'فيديوهات تعليمية', 'موشن جرافيك'],
      socialMedia: {
        'instagram': 'https://instagram.com/sara_videoeditor',
        'linkedin': 'https://linkedin.com/in/sara-videoedit',
      },
      joinDate: DateTime.now().subtract(const Duration(days: 1825)), // 5 سنوات
    ),
    ServiceProvider(
      name: 'محمد علي قاسم',
      service: 'photo-editor',
      city: 'نابلس',
      phone: '0598789123',
      email: 'mohammed.photoedit@example.com',
      description: 'خبير في تعديل الصور باستخدام الفوتوشوب والبرامج المتقدمة. أقدم خدمات تعديل الصور الاحترافية للمصورين والأفراد.',
      profileImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=300',
      portfolioImages: [
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd65?w=400',
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd66?w=400',
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd67?w=400',
      ],
      rating: 4.9,
      reviewsCount: 89,
      workHours: 'يومياً: 2 مساءً - 11 مساءً',
      isVerified: true,
      specialties: ['ريتوتش صور', 'إزالة خلفيات', 'تلوين صور', 'تصحيح ألوان'],
      socialMedia: {
        'facebook': 'https://facebook.com/mohammed.photoedit',
        'instagram': 'https://instagram.com/mohammed_retoucher',
      },
      joinDate: DateTime.now().subtract(const Duration(days: 1460)), // 4 سنوات
    ),
    ServiceProvider(
      name: 'فاطمة حسن النجار',
      service: 'printer',
      city: 'القدس',
      phone: '0596543210',
      email: 'fatima.print@example.com',
      description: 'متخصصة في طباعة الصور عالية الجودة وتصميم الألبومات والإطارات المخصصة. نوفر جميع أنواع الطباعة الرقمية.',
      profileImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=300',
      portfolioImages: [
        'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=400',
        'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e1?w=400',
        'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e2?w=400',
      ],
      rating: 4.7,
      reviewsCount: 56,
      workHours: 'السبت - الخميس: 9 صباحاً - 6 مساءً',
      isVerified: false,
      specialties: ['طباعة كانفاس', 'ألبومات زفاف', 'إطارات مخصصة', 'طباعة بانوراما'],
      socialMedia: {
        'facebook': 'https://facebook.com/fatima.printshop',
      },
      joinDate: DateTime.now().subtract(const Duration(days: 1095)), // 3 سنوات
    ),
    ServiceProvider(
      name: 'يوسف محمود عطا',
      service: 'photographer',
      city: 'الخليل',
      phone: '0592468135',
      email: 'youssef.photo@example.com',
      description: 'مصور فوتوغرافي متخصص في تصوير الطبيعة والمناظر الطبيعية والتصوير المعماري.',
      profileImage: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300',
      portfolioImages: [
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
        'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=400',
        'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?w=400',
        'https://images.unsplash.com/photo-1517760444937-f6397edcbbcd?w=400',
        'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400',
        'https://images.unsplash.com/photo-1519981593452-666cf05569a9?w=400',
      ],
      rating: 4.5,
      reviewsCount: 23,
      workHours: 'مرن حسب الطلب',
      isVerified: false,
      specialties: ['تصوير طبيعة', 'تصوير معماري', 'تصوير جوي', 'تصوير ليلي'],
      socialMedia: {
        'instagram': 'https://instagram.com/youssef_landscape',
        'facebook': 'https://facebook.com/youssef.photographer',
      },
      joinDate: DateTime.now().subtract(const Duration(days: 730)), // سنتان
    ),
    ServiceProvider(
      name: 'ريم خالد عبدالله',
      service: 'video-editor',
      city: 'بيت لحم',
      phone: '0593571248',
      description: 'محررة فيديو مبدعة متخصصة في الأفلام التوثيقية والقصص الشخصية.',
      portfolioImages: [
        'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=400',
        'https://images.unsplash.com/photo-1611532736597-de2d4265fba4?w=400',
      ],
      rating: 4.3,
      reviewsCount: 15,
      workHours: 'الأحد - الثلاثاء: 1 مساءً - 9 مساءً',
      isVerified: false,
      specialties: ['أفلام توثيقية', 'قصص شخصية', 'فيديوهات اجتماعية'],
      joinDate: DateTime.now().subtract(const Duration(days: 365)), // سنة واحدة
    ),
  ];

  List<ServiceProvider> filteredProviders = [];
  String searchTerm = '';
  String? selectedCity;
  String? selectedService;
  bool hasEmail = false;
  String sortBy = 'name';

  @override
  void initState() {
    super.initState();
    filteredProviders = allProviders;
  }

  void _applyFilters() {
    setState(() {
      filteredProviders = allProviders.where((provider) {
        final matchesSearch = provider.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
            provider.getServiceLabel().toLowerCase().contains(searchTerm.toLowerCase()) ||
            provider.city.toLowerCase().contains(searchTerm.toLowerCase());

        final matchesCity = selectedCity == null || provider.city == selectedCity;
        final matchesService = selectedService == null || provider.service == selectedService;
        final matchesEmail = !hasEmail || (provider.email != null && provider.email!.isNotEmpty);

        return matchesSearch && matchesCity && matchesService && matchesEmail;
      }).toList();

      // ترتيب النتائج
      filteredProviders.sort((a, b) {
        switch (sortBy) {
          case 'name':
            return a.name.compareTo(b.name);
          case 'city':
            return a.city.compareTo(b.city);
          case 'service':
            return a.getServiceLabel().compareTo(b.getServiceLabel());
          case 'rating':
            return b.rating.compareTo(a.rating); // ترتيب تنازلي للتقييم
          case 'experience':
            return a.joinDate.compareTo(b.joinDate); // الأقدم أولاً
          default:
            return 0;
        }
      });
    });
  }

  void _clearFilters() {
    setState(() {
      searchTerm = '';
      selectedCity = null;
      selectedService = null;
      hasEmail = false;
      sortBy = 'name';
      filteredProviders = allProviders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          children: [
            Text(
              'البحث عن خدمات',
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ابحث عن مقدمي الخدمات في منطقتك',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: Column(
        children: [
          // شريط البحث والفلاتر
          SearchFilters(
            searchTerm: searchTerm,
            selectedCity: selectedCity,
            selectedService: selectedService,
            hasEmail: hasEmail,
            sortBy: sortBy,
            allProviders: allProviders,
            onSearchChanged: (value) {
              searchTerm = value;
              _applyFilters();
            },
            onCityChanged: (value) {
              selectedCity = value;
              _applyFilters();
            },
            onServiceChanged: (value) {
              selectedService = value;
              _applyFilters();
            },
            onEmailChanged: (value) {
              hasEmail = value;
              _applyFilters();
            },
            onSortChanged: (value) {
              sortBy = value;
              _applyFilters();
            },
            onClearFilters: _clearFilters,
            resultsCount: filteredProviders.length,
            totalCount: allProviders.length,
          ),

          // النتائج
          Expanded(
            child: filteredProviders.isEmpty
                ? _buildEmptyResults()
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: filteredProviders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ServiceProviderCard(
                      provider: filteredProviders[index],
                      showContactButtons: true,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.search_off,
              size: 60,
              color: Color(0xFF94A3B8),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'لا توجد نتائج',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'جرب تغيير معايير البحث',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}