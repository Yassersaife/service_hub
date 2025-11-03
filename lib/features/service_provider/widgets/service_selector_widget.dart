// lib/features/service_provider/widgets/service_selector_widget.dart

import 'package:Lumixy/models/service.dart';
import 'package:flutter/material.dart';
import 'package:Lumixy/core/utils/app_colors.dart';
import 'package:Lumixy/features/service_provider/services/provider_service.dart';

class ServiceSelectorWidget extends StatefulWidget {
  final int? categoryId;
  final List<Service> selectedServices;
  final Function(List<Service>) onServicesChanged;
  final int? minServices;
  final int? maxServices;

  const ServiceSelectorWidget({
    Key? key,
    required this.categoryId,
    required this.selectedServices,
    required this.onServicesChanged,
    this.minServices = 1,
    this.maxServices,
  }) : super(key: key);

  @override
  State<ServiceSelectorWidget> createState() => _ServiceSelectorWidgetState();
}


class _ServiceSelectorWidgetState extends State<ServiceSelectorWidget> {
  final _providerService = ProviderService();
  List<Service> _availableServices = [];
  List<Service> _selectedServices = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedServices = List<Service>.from(widget.selectedServices);
    _loadServices();
  }

  @override
  void didUpdateWidget(ServiceSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.categoryId != widget.categoryId) {
      _selectedServices.clear();
      _loadServices();
    }
  }

  Future<void> _loadServices() async {
    if (widget.categoryId == null) {
      setState(() {
        _isLoading = false;
        _availableServices = [];
        _errorMessage = 'يرجى اختيار التصنيف أولاً';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final services = await _providerService.getCategoryServices(widget.categoryId!);

      setState(() {
        _availableServices = services;
        _isLoading = false;

        if (services.isEmpty) {
          _errorMessage = 'لا توجد خدمات متاحة لهذا التصنيف';
        }
      });
    } catch (e) {
      print('❌ خطأ في تحميل الخدمات: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'فشل تحميل الخدمات';
      });
    }
  }

  void _toggleService(Service service) {
    setState(() {
      final isSelected = _selectedServices.any((s) => s.id == service.id);

      if (isSelected) {
        _selectedServices.removeWhere((s) => s.id == service.id);
      } else {
        if (widget.maxServices != null &&
            _selectedServices.length >= widget.maxServices!) {
          _showMessage(
            'يمكنك اختيار ${widget.maxServices} خدمات كحد أقصى',
            isError: true,
          );
          return;
        }

        _selectedServices.add(service);
      }

      widget.onServicesChanged(_selectedServices);
    });
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildContent(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.work_outline,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'التخصصات والخدمات',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              if (widget.minServices != null || widget.maxServices != null)
                Text(
                  _getServicesRangeText(),
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ),
        if (_selectedServices.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_selectedServices.length} مختارة',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  String _getServicesRangeText() {
    if (widget.minServices != null && widget.maxServices != null) {
      return 'اختر من ${widget.minServices} إلى ${widget.maxServices} خدمات';
    } else if (widget.minServices != null) {
      return 'اختر ${widget.minServices} ${widget.minServices == 1 ? 'خدمة' : 'خدمات'} على الأقل';
    } else if (widget.maxServices != null) {
      return 'اختر ${widget.maxServices} ${widget.maxServices == 1 ? 'خدمة' : 'خدمات'} كحد أقصى';
    }
    return '';
  }

  Widget _buildContent() {
    if (widget.categoryId == null) {
      return _buildEmptyState(
        icon: Icons.category_outlined,
        message: 'يرجى اختيار التصنيف أولاً',
      );
    }

    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_availableServices.isEmpty) {
      return _buildEmptyState(
        icon: Icons.work_off_outlined,
        message: 'لا توجد خدمات متاحة لهذا التصنيف',
      );
    }

    return _buildServicesList();
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: const Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'جاري تحميل الخدمات...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _errorMessage ?? 'حدث خطأ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: _loadServices,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _availableServices.map((service) {
        final isSelected = _selectedServices.any((s) => s.id == service.id);

        return _buildServiceChip(service, isSelected);
      }).toList(),
    );
  }

  Widget _buildServiceChip(Service service, bool isSelected) {
    return FilterChip(
      label: Text(service.name),
      selected: isSelected,
      onSelected: (_) => _toggleService(service),
      avatar: isSelected
          ? null
          : Icon(
        service.getServiceIcon(),
        size: 18,
        color: service.getPrimaryColor(),
      ),
      selectedColor: service.getPrimaryColor().withOpacity(0.15),
      checkmarkColor: service.getPrimaryColor(),
      backgroundColor: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? service.getPrimaryColor()
              : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      labelStyle: TextStyle(
        color: isSelected ? service.getPrimaryColor() : const Color(0xFF475569),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

}
