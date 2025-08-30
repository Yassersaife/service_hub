
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
  final String? categoryName;

  const CustomerServicesScreen({
    super.key,
    this.initialServiceType,
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
    _selectedService = widget.initialServiceType; // الفلتر المبدئي
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await Future.wait([
        _providerService.getAllProviders(),
        ServicesApiService.getAllServiceCategories(),
      ]);

      setState(() {
        _allProviders = results[0] as List<ProviderProfile>;
        _serviceCategories = results[1] as List<ServiceCategory>;
        _isLoading = false;
      });

      _applyFilters();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredProviders = _allProviders.where((provider) {
        final matchesSearch = _searchTerm.isEmpty ||
            provider.getServiceLabel().toLowerCase().contains(_searchTerm.toLowerCase()) ||
            provider.city.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            (provider.name?.toLowerCase().contains(_searchTerm.toLowerCase()) ?? false);

        final matchesCity = _selectedCity == null || provider.city == _selectedCity;

        final matchesService = _selectedService == null ||
            provider.serviceType == _selectedService;

        return matchesSearch && matchesCity && matchesService;
      }).toList();

      // ترتيب بسيط
      _filteredProviders.sort((a, b) {
        switch (_sortBy) {
          case 'city': return a.city.compareTo(b.city);
          case 'service': return a.getServiceLabel().compareTo(b.getServiceLabel());
          default: return 0;
        }
      });
    });
  }

  void _clearFilters() {
    setState(() {
      _searchTerm = '';
      _selectedCity = null;
      _selectedService = widget.initialServiceType;
      _sortBy = 'name';
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CircularProgressIndicator()),
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
                ? const Center(child: Text('لا توجد نتائج'))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredProviders.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ServiceProviderCardGuest(
                    profile: _filteredProviders[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}