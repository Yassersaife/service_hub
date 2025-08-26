import 'package:flutter/material.dart';
import 'package:service_hub/features/service_provider/models/provider_profile.dart';
import 'package:service_hub/models/service_models.dart';
import 'package:service_hub/services/services_api_service.dart';
import '../../../core/utils/app_colors.dart';
import '../../service_provider/services/provider_service.dart';
import '../../../widgets/service_provider_card_guest.dart';
import '../../../widgets/search_filters_guest.dart';

class CustomerServicesScreen extends StatefulWidget {
  final String? initialServiceType;
  final String? categoryId;
  final String? categoryName;

  const CustomerServicesScreen({
    super.key,
    this.initialServiceType,
    this.categoryId,
    this.categoryName,
  });
  @override
  State<CustomerServicesScreen> createState() => _CustomerServicesScreenState();
}

class _CustomerServicesScreenState extends State<CustomerServicesScreen> {
  final _providerService = ProviderService();

  List<ProviderProfile> _allProviders = [];
  List<ProviderProfile> _filteredProviders = [];
  bool _isLoading = true;
  List<ServiceCategory> _serviceCategories = [];

  String _searchTerm = '';
  String? _selectedCity;
  String? _selectedService;
  String _sortBy = 'name';

  @override
  void initState() {
    super.initState();
    _selectedService = widget.initialServiceType;
    _loadProviders();
  }

  void _loadProviders() async {
    setState(() {
      _isLoading = true;
    });

    final providers = await _providerService.getAllProviders();
    final categories = await ServicesApiService.getAllServiceCategories();

    setState(() {
      _allProviders = providers;
      _filteredProviders = providers;
      _serviceCategories = categories;
      _isLoading = false;
    });

    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredProviders = _allProviders.where((provider) {
        final matchesSearch = provider.getServiceLabel().toLowerCase().contains(_searchTerm.toLowerCase()) ||
            provider.city.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            (provider.description?.toLowerCase().contains(_searchTerm.toLowerCase()) ?? false);

        final matchesCity = _selectedCity == null || provider.city == _selectedCity;
        final matchesService = _selectedService == null || provider.serviceType == _selectedService;

        return matchesSearch && matchesCity && matchesService;
      }).toList();

      _filteredProviders.sort((a, b) {
        switch (_sortBy) {
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
      _searchTerm = '';
      _selectedCity = null;
      _selectedService = null;
      _sortBy = 'name';
      _filteredProviders = _allProviders;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'جاري تحميل مقدمي الخدمات...',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
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
              'اعثر على مقدمي الخدمات المناسبين لك',
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
        automaticallyImplyLeading: widget.initialServiceType != null ? true : false,
      ),
      body: Column(
        children: [
          SearchFiltersGuest(
            searchTerm: _searchTerm,
            selectedCity: _selectedCity,
            selectedService: _selectedService,
            sortBy: _sortBy,
            allCategories: _serviceCategories,
            allProviders: _allProviders,
            onSearchChanged: (value) {
              _searchTerm = value;
              _applyFilters();
            },
            onCityChanged: (value) {
              _selectedCity = value;
              _applyFilters();
            },
            onServiceChanged: (value) {
              _selectedService = value;
              _applyFilters();
            },
            onSortChanged: (value) {
              _sortBy = value;
              _applyFilters();
            },
            onClearFilters: _clearFilters,
            resultsCount: _filteredProviders.length,
            totalCount: _allProviders.length,
          ),

          Expanded(
            child: _filteredProviders.isEmpty
                ? _buildEmptyResults()
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: _filteredProviders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ServiceProviderCardGuest(
                      profile: _filteredProviders[index],
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
            'جرب تغيير معايير البحث أو المرشحات',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF94A3B8),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.refresh),
            label: const Text('مسح المرشحات'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}