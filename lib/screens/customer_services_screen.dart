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
  // بيانات تجريبية
  List<ServiceProvider> allProviders = [
    ServiceProvider(
      name: 'أحمد محمد',
      service: 'photographer',
      city: 'نابلس',
      phone: '0599123456',
      email: 'ahmed@example.com',
      description: 'مصور محترف متخصص في التصوير الفوتوغرافي والأعراس',
    ),
    ServiceProvider(
      name: 'سارة أحمد',
      service: 'video-editor',
      city: 'رام الله',
      phone: '0597654321',
      description: 'متخصصة في مونتاج الفيديوهات والأفلام القصيرة',
    ),
    ServiceProvider(
      name: 'محمد علي',
      service: 'photo-editor',
      city: 'نابلس',
      phone: '0598789123',
      email: 'mohammed@example.com',
      description: 'خبير في تعديل الصور باستخدام الفوتوشوب',
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