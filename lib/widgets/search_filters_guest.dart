// lib/widgets/search_filters_guest.dart
import 'package:flutter/material.dart';
import 'package:Lumixy/features/service_provider/models/provider_profile.dart';
import 'package:Lumixy/models/service.dart';
import 'package:Lumixy/models/category.dart';
import '../core/utils/app_colors.dart';

class SearchFiltersGuest extends StatefulWidget {
  final String searchTerm;
  final String? selectedCity;
  final String? selectedService;
  final String? selectedCategory;
  final String sortBy;
  final List<ProviderProfile> allProviders;
  final Function(String) onSearchChanged;
  final Function(String?) onCityChanged;
  final Function(String?) onServiceChanged;
  final Function(String?) onCategoryChanged;
  final Function(String) onSortChanged;
  final VoidCallback onClearFilters;
  final int resultsCount;
  final int totalCount;
  final List<Category> allCategories;
  final List<Service> allServices;

  const SearchFiltersGuest({
    super.key,
    required this.searchTerm,
    required this.selectedCity,
    required this.selectedService,
    this.selectedCategory,
    required this.sortBy,
    required this.allProviders,
    required this.onSearchChanged,
    required this.onCityChanged,
    required this.onServiceChanged,
    required this.onCategoryChanged,
    required this.onSortChanged,
    required this.onClearFilters,
    required this.resultsCount,
    required this.totalCount,
    required this.allCategories,
    required this.allServices,
  });

  @override
  State<SearchFiltersGuest> createState() => _SearchFiltersGuestState();
}

class _SearchFiltersGuestState extends State<SearchFiltersGuest>
    with SingleTickerProviderStateMixin {
  bool showAdvancedFilters = false;
  late TextEditingController _searchController;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchTerm);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(SearchFiltersGuest oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchTerm != widget.searchTerm) {
      _searchController.text = widget.searchTerm;
    }
  }

  void _toggleAdvancedFilters() {
    setState(() {
      showAdvancedFilters = !showAdvancedFilters;
      if (showAdvancedFilters) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cities = _getUniqueCities();
    final hasActiveFilters = widget.selectedCity != null ||
        widget.selectedService != null ||
        widget.selectedCategory != null ||
        widget.searchTerm.isNotEmpty;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // شريط البحث
                _buildSearchBar(),

                const SizedBox(height: 16),

                // شريط النتائج والفلاتر
                _buildResultsBar(hasActiveFilters),
              ],
            ),
          ),

          // الفلاتر المتقدمة
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'فلاتر متقدمة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAdvancedFilters(cities),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: widget.onSearchChanged,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          hintText: 'ابحث عن نوع الخدمة أو المدينة أو اسم المقدم...',
          hintStyle: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 14,
          ),
          prefixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, color: Color(0xFF64748B)),
            onPressed: () {
              _searchController.clear();
              widget.onSearchChanged('');
            },
          )
              : null,
          suffixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
          filled: false,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildResultsBar(bool hasActiveFilters) {
    return Row(
      children: [
        // عدد النتائج
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                '${widget.resultsCount} من ${widget.totalCount}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        // زر مسح الفلاتر
        if (hasActiveFilters) ...[
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton.icon(
              onPressed: widget.onClearFilters,
              icon: const Icon(Icons.clear_all, size: 16),
              label: const Text('مسح الكل'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFDC2626),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],

        // زر الفلاتر المتقدمة
        Container(
          decoration: BoxDecoration(
            color: showAdvancedFilters
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton.icon(
            onPressed: _toggleAdvancedFilters,
            icon: AnimatedRotation(
              turns: showAdvancedFilters ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                showAdvancedFilters ? Icons.expand_less : Icons.tune,
                size: 18,
              ),
            ),
            label: const Text('فلاتر'),
            style: TextButton.styleFrom(
              foregroundColor: showAdvancedFilters
                  ? AppColors.primary
                  : const Color(0xFF64748B),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedFilters(List<String> cities) {
    return Column(
      children: [
        // الصف الأول: المدينة + الفئة
        Row(
          children: [
            Expanded(
              child: _buildFilterDropdown(
                label: 'المدينة',
                value: widget.selectedCity,
                items: ['الكل', ...cities.toSet().toList()],
                onChanged: (value) {
                  widget.onCityChanged(value == 'الكل' ? null : value);
                },
                icon: Icons.location_on,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFilterDropdown(
                label: 'فئة الخدمة',
                value: widget.selectedCategory,
                items: [
                  'الكل',
                  ...widget.allCategories.map((c) => c.id.toString()).toList()
                ],
                itemLabels: [
                  'الكل',
                  ...widget.allCategories.map((c) => c.name).toList()
                ],
                onChanged: (value) {
                  widget.onCategoryChanged(value == 'الكل' ? null : value);
                },
                icon: Icons.category,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // الصف الثاني: التخصص + الترتيب
        Row(
          children: [
            Expanded(
              child: _buildFilterDropdown(
                label: 'التخصص',
                value: widget.selectedService,
                items: [
                  'الكل',
                  ...widget.allServices.map((s) => s.id.toString()).toList()
                ],
                itemLabels: [
                  'الكل',
                  ...widget.allServices.map((s) => s.name).toList()
                ],
                onChanged: (value) {
                  widget.onServiceChanged(value == 'الكل' ? null : value);
                },
                icon: Icons.work,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFilterDropdown(
                label: 'ترتيب حسب',
                value: widget.sortBy,
                items: const ['name', 'city', 'category', 'featured'],
                itemLabels: const ['الاسم', 'المدينة', 'الفئة', 'المميز أولاً'],
                onChanged: (value) {
                  if (value != null) widget.onSortChanged(value);
                },
                icon: Icons.sort,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required List<String> items,
    List<String>? itemLabels,
    required Function(String?) onChanged,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: const Color(0xFF64748B)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              isDense: true,
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1E293B),
            ),
            items: items.map((String item) {
              final displayLabel = itemLabels != null &&
                  items.indexOf(item) < itemLabels.length
                  ? itemLabels[items.indexOf(item)]
                  : item;

              return DropdownMenuItem<String>(
                value: item,
                child: Text(displayLabel),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  List<String> _getUniqueCities() {
    final cities = widget.allProviders
        .where((p) => p.city.isNotEmpty)
        .map((p) => p.city)
        .toSet()
        .toList();
    cities.sort();
    return cities;
  }
}