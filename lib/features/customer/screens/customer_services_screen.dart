import 'package:flutter/material.dart';
import 'package:service_hub/features/service_provider/models/provider_profile.dart';
import 'package:service_hub/models/category.dart';
import 'package:service_hub/models/service.dart';
import 'package:service_hub/services/services_api_service.dart';
import '../../../core/utils/app_colors.dart';
import '../../service_provider/services/provider_service.dart';
import '../../../widgets/service_provider_card_guest.dart';
import '../../../widgets/search_filters_guest.dart';

class CustomerServicesScreen extends StatefulWidget {
  final String? initialCategoryId;
  final String? categoryName;
  final String? initialServiceId;

  const CustomerServicesScreen({
    super.key,
    this.initialCategoryId,
    this.categoryName,
    this.initialServiceId,
  });

  @override
  State<CustomerServicesScreen> createState() => _CustomerServicesScreenState();
}

class _CustomerServicesScreenState extends State<CustomerServicesScreen> {
  final _providerService = ProviderService();
  final ScrollController _scrollController = ScrollController();

  List<ProviderProfile> _allProviders = [];
  List<ProviderProfile> _filteredProviders = [];
  bool _isLoading = true;
  List<Category> _categories = [];
  List<Service> _services = [];

  String _searchTerm = '';
  String? _selectedCity;
  String? _selectedService;
  String? _selectedCategory;
  String _sortBy = 'name';

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategoryId;
    _selectedService = widget.initialServiceId;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await Future.wait([
        _providerService.getAllProviders(),
        ServicesApiService.getAllCategories(),
        ServicesApiService.getAllServices(),
      ]);

      setState(() {
        _allProviders = results[0] as List<ProviderProfile>;
        _categories = results[1] as List<Category>;
        _services = results[2] as List<Service>;
        _isLoading = false;
      });

      _applyFilters();
    } catch (e) {
      print('خطأ في تحميل البيانات: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredProviders = _allProviders.where((provider) {
        // فلتر البحث
        final matchesSearch = _searchTerm.isEmpty ||
            provider.displayName.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            provider.city.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            (provider.categoryName?.toLowerCase().contains(_searchTerm.toLowerCase()) ?? false);

        // فلتر المدينة
        final matchesCity = _selectedCity == null || provider.city == _selectedCity;

        // فلتر الفئة
        final matchesCategory = _selectedCategory == null ||
            provider.categoryId?.toString() == _selectedCategory;

        // فلتر الخدمة (التحقق من الخدمات المرتبطة بالمزود)
        bool matchesService = _selectedService == null;
        if (_selectedService != null && provider.services != null) {
          matchesService = provider.services!.any(
                  (service) => service['id']?.toString() == _selectedService
          );
        } else if (_selectedService == null) {
          matchesService = true;
        }

        return matchesSearch && matchesCity && matchesCategory && matchesService;
      }).toList();

      // تطبيق الترتيب
      _filteredProviders.sort((a, b) {
        switch (_sortBy) {
          case 'city':
            return a.city.compareTo(b.city);
          case 'category':
            final aCat = a.categoryName ?? '';
            final bCat = b.categoryName ?? '';
            return aCat.compareTo(bCat);
          case 'featured':
            if (a.isFeatured && !b.isFeatured) return -1;
            if (!a.isFeatured && b.isFeatured) return 1;
            if (a.isVerified && !b.isVerified) return -1;
            if (!a.isVerified && b.isVerified) return 1;
            return 0;
          case 'name':
          default:
            return a.displayName.compareTo(b.displayName);
        }
      });
    });
  }

  void _clearFilters() {
    setState(() {
      _searchTerm = '';
      _selectedCity = null;
      _selectedService = widget.initialServiceId;
      _selectedCategory = widget.initialCategoryId;
      _sortBy = 'name';
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'جاري التحميل...',
            style: TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'جاري تحميل مقدمي الخدمات...',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.categoryName ?? 'البحث عن خدمات',
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: Column(
        children: [
          SearchFiltersGuest(
            searchTerm: _searchTerm,
            selectedCity: _selectedCity,
            selectedService: _selectedService,
            selectedCategory: _selectedCategory,
            sortBy: _sortBy,
            allCategories: _categories,
            allServices: _services,
            allProviders: _allProviders,
            onSearchChanged: (value) {
              setState(() {
                _searchTerm = value;
              });
              _applyFilters();
            },
            onCityChanged: (value) {
              setState(() {
                _selectedCity = value;
              });
              _applyFilters();
            },
            onServiceChanged: (value) {
              setState(() {
                _selectedService = value;
              });
              _applyFilters();
            },
            onCategoryChanged: (value) {
              setState(() {
                _selectedCategory = value;
              });
              _applyFilters();
            },
            onSortChanged: (value) {
              setState(() {
                _sortBy = value;
              });
              _applyFilters();
            },
            onClearFilters: _clearFilters,
            resultsCount: _filteredProviders.length,
            totalCount: _allProviders.length,
          ),

          Expanded(
            child: _buildProvidersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProvidersList() {
    if (_filteredProviders.isEmpty) {
      return Scrollbar(
        controller: _scrollController, // استخدم هذا الكنترولر
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController, // نفس الكنترولر
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.search_off,
                      size: 50,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'لا توجد نتائج مطابقة',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'جرب تعديل معايير البحث',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _clearFilters,
                    icon: const Icon(Icons.clear_all),
                    label: const Text('مسح جميع الفلاتر'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: Scrollbar(
        controller: _scrollController, // نفس الكنترولر
        thumbVisibility: true,
        child: ListView.builder(
          controller: _scrollController, // نفس الكنترولر
          padding: const EdgeInsets.all(16),
          itemCount: _filteredProviders.length,
          itemBuilder: (context, index) {
            final provider = _filteredProviders[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ServiceProviderCardGuest(
                profile: provider,
              ),
            );
          },
        ),
      ),
    );
  }
}

