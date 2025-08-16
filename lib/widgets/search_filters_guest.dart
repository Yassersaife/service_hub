// lib/widgets/search_filters_guest.dart
import 'package:flutter/material.dart';
import '../features/service_provider/models/provider_profile.dart';
import '../utils/app_colors.dart';

class SearchFiltersGuest extends StatefulWidget {
  final String searchTerm;
  final String? selectedCity;
  final String? selectedService;
  final String sortBy;
  final List<ProviderProfile> allProviders;
  final Function(String) onSearchChanged;
  final Function(String?) onCityChanged;
  final Function(String?) onServiceChanged;
  final Function(String) onSortChanged;
  final VoidCallback onClearFilters;
  final int resultsCount;
  final int totalCount;

  const SearchFiltersGuest({
    super.key,
    required this.searchTerm,
    required this.selectedCity,
    required this.selectedService,
    required this.sortBy,
    required this.allProviders,
    required this.onSearchChanged,
    required this.onCityChanged,
    required this.onServiceChanged,
    required this.onSortChanged,
    required this.onClearFilters,
    required this.resultsCount,
    required this.totalCount,
  });

  @override
  State<SearchFiltersGuest> createState() => _SearchFiltersGuestState();
}

class _SearchFiltersGuestState extends State<SearchFiltersGuest> {
  bool showAdvancedFilters = false;
  late TextEditingController _searchController;

  final List<Map<String, String>> _serviceTypes = [
    {'value': 'photographer', 'label': 'مصور'},
    {'value': 'video-editor', 'label': 'مونتاج فيديوهات'},
    {'value': 'photo-editor', 'label': 'تعديل صور'},
    {'value': 'printer', 'label': 'طباعة صور'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchTerm);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cities = widget.allProviders.map((p) => p.city).toSet().toList()..sort();
    final hasActiveFilters = widget.selectedCity != null || widget.selectedService != null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // شريط البحث الرئيسي
          TextField(
            controller: _searchController,
            onChanged: widget.onSearchChanged,
            decoration: InputDecoration(
              hintText: 'ابحث عن نوع الخدمة أو المدينة...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // شريط المعلومات والتحكم
          Row(
            children: [
              // عداد النتائج
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.resultsCount} من ${widget.totalCount}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // زر الفلاتر
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    showAdvancedFilters = !showAdvancedFilters;
                  });
                },
                icon: Icon(
                  showAdvancedFilters ? Icons.expand_less : Icons.tune,
                  size: 18,
                ),
                label: const Text('فلاتر'),
                style: TextButton.styleFrom(
                  foregroundColor: showAdvancedFilters
                      ? AppColors.primary
                      : const Color(0xFF64748B),
                  backgroundColor: showAdvancedFilters
                      ? AppColors.primary.withOpacity(0.1)
                      : null,
                ),
              ),

              if (hasActiveFilters) ...[
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton.icon(
                    onPressed: widget.onClearFilters,
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('مسح'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ],
          ),

          // الفلاتر المتقدمة
          if (showAdvancedFilters) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterDropdown(
                          label: 'المدينة',
                          value: widget.selectedCity,
                          items: ['الكل', ...cities],
                          onChanged: (value) {
                            widget.onCityChanged(value == 'الكل' ? null : value);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFilterDropdown(
                          label: 'نوع الخدمة',
                          value: widget.selectedService,
                          items: ['الكل', ..._serviceTypes.map((e) => e['value']!)],
                          onChanged: (value) {
                            widget.onServiceChanged(value == 'الكل' ? null : value);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  _buildFilterDropdown(
                    label: 'ترتيب حسب',
                    value: widget.sortBy,
                    items: const ['name', 'city', 'service', 'rating'],
                    itemLabels: const ['الاسم', 'المدينة', 'نوع الخدمة', 'التقييم'],
                    onChanged: (value) {
                      if (value != null) widget.onSortChanged(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required List<String> items,
    List<String>? itemLabels,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              isDense: true,
            ),
            items: items.map((String item) {
              final displayLabel = itemLabels != null && items.indexOf(item) < itemLabels.length
                  ? itemLabels[items.indexOf(item)]
                  : _getDisplayLabel(item);

              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  displayLabel,
                  style: const TextStyle(fontSize: 12),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  String _getDisplayLabel(String item) {
    switch (item) {
      case 'photographer':
        return 'مصور';
      case 'video-editor':
        return 'مونتاج فيديوهات';
      case 'photo-editor':
        return 'تعديل صور';
      case 'printer':
        return 'طباعة صور';
      default:
        return item;
    }
  }

  IconData _getServiceIcon(String serviceType) {
    switch (serviceType) {
      case 'photographer':
        return Icons.camera_alt;
      case 'video-editor':
        return Icons.video_camera_back;
      case 'photo-editor':
        return Icons.edit;
      case 'printer':
        return Icons.print;
      default:
        return Icons.work;
    }
  }
}