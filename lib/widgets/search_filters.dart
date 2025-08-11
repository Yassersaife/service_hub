import 'package:flutter/material.dart';
import '../models/service_provider.dart';
import '../utils/app_colors.dart';

class SearchFilters extends StatefulWidget {
  final String searchTerm;
  final String? selectedCity;
  final String? selectedService;
  final bool hasEmail;
  final String sortBy;
  final List<ServiceProvider> allProviders;
  final Function(String) onSearchChanged;
  final Function(String?) onCityChanged;
  final Function(String?) onServiceChanged;
  final Function(bool) onEmailChanged;
  final Function(String) onSortChanged;
  final VoidCallback onClearFilters;
  final int resultsCount;
  final int totalCount;

  const SearchFilters({
    super.key,
    required this.searchTerm,
    required this.selectedCity,
    required this.selectedService,
    required this.hasEmail,
    required this.sortBy,
    required this.allProviders,
    required this.onSearchChanged,
    required this.onCityChanged,
    required this.onServiceChanged,
    required this.onEmailChanged,
    required this.onSortChanged,
    required this.onClearFilters,
    required this.resultsCount,
    required this.totalCount,
  });

  @override
  State<SearchFilters> createState() => _SearchFiltersState();
}

class _SearchFiltersState extends State<SearchFilters> {
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
  Widget build(BuildContext context) {
    final cities = widget.allProviders.map((p) => p.city).toSet().toList()..sort();
    final hasActiveFilters = widget.selectedCity != null ||
        widget.selectedService != null ||
        widget.hasEmail;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
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
              hintText: 'ابحث عن الاسم، نوع الخدمة، أو المدينة...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFF64748B)),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // أزرار التحكم
          Row(
            children: [
              // زر الفلاتر المتقدمة
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      showAdvancedFilters = !showAdvancedFilters;
                    });
                  },
                  icon: Icon(
                    showAdvancedFilters ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                  ),
                  label: const Text('فلاتر متقدمة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showAdvancedFilters
                        ? AppColors.primary
                        : const Color(0xFFF1F5F9),
                    foregroundColor: showAdvancedFilters
                        ? Colors.white
                        : const Color(0xFF64748B),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              if (hasActiveFilters) ...[
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: widget.onClearFilters,
                  icon: const Icon(Icons.clear, size: 16),
                  label: const Text('مسح'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEE2E2),
                    foregroundColor: const Color(0xFFDC2626),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],

              const SizedBox(width: 8),

              // عداد النتائج
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.resultsCount}/${widget.totalCount}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),

          // الفلاتر المتقدمة
          if (showAdvancedFilters) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  // المدينة ونوع الخدمة
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterDropdown(
                          label: 'المدينة',
                          value: widget.selectedCity,
                          items: ['جميع المدن', ...cities],
                          onChanged: (value) {
                            widget.onCityChanged(value == 'جميع المدن' ? null : value);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFilterDropdown(
                          label: 'نوع الخدمة',
                          value: widget.selectedService,
                          items: ['جميع الخدمات', ..._serviceTypes.map((e) => e['value']!)],
                          onChanged: (value) {
                            widget.onServiceChanged(value == 'جميع الخدمات' ? null : value);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // الترتيب والخيارات الإضافية
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterDropdown(
                          label: 'ترتيب حسب',
                          value: widget.sortBy,
                          items: const ['name', 'city', 'service'],
                          itemLabels: const ['الاسم', 'المدينة', 'نوع الخدمة'],
                          onChanged: (value) {
                            if (value != null) widget.onSortChanged(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CheckboxListTile(
                          title: const Text(
                            'لديه بريد إلكتروني',
                            style: TextStyle(fontSize: 12),
                          ),
                          value: widget.hasEmail,
                          onChanged: (value) {
                            widget.onEmailChanged(value ?? false);
                          },
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // إحصائيات سريعة
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'إحصائيات سريعة:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 16,
                          runSpacing: 4,
                          children: _serviceTypes.map((service) {
                            final count = widget.allProviders
                                .where((p) => p.service == service['value'])
                                .length;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getServiceIcon(service['value']!),
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${service['label']}: $count',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
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
                  : (item.startsWith('photographer') ? 'مصور' :
              item.startsWith('video-editor') ? 'مونتاج فيديوهات' :
              item.startsWith('photo-editor') ? 'تعديل صور' :
              item.startsWith('printer') ? 'طباعة صور' : item);

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
