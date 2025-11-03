// lib/screens/admin/tabs/providers_tab.dart

import 'package:flutter/material.dart';
import 'package:Lumixy/features/service_provider/models/provider_profile.dart';
import 'package:Lumixy/features/service_provider/services/provider_service.dart';
import 'package:Lumixy/services/admin_service.dart';
import '../../../core/utils/app_colors.dart';

class ProvidersTab extends StatefulWidget {
  const ProvidersTab({super.key});

  @override
  State<ProvidersTab> createState() => _ProvidersTabState();
}

class _ProvidersTabState extends State<ProvidersTab> {
  List<ProviderProfile> _allProviders = [];
  bool _isLoading = true;
  final _adminService = AdminService();
  final _providerService = ProviderService();

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final providers = await _providerService.getAllProvidersAdmin();

      if (mounted) {
        setState(() {
          _allProviders = providers;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('خطأ في تحميل المقدمين: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_allProviders.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildQuickStats(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadProviders,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _allProviders.length,
              itemBuilder: (context, index) {
                return _buildProviderCard(_allProviders[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'لا يوجد مقدمو خدمات بعد',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadProviders,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final totalProviders = _allProviders.length;
    final verifiedProviders = _allProviders.where((p) => p.isVerified).length;
    final featuredProviders = _allProviders.where((p) => p.isFeatured).length;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              'المجموع',
              totalProviders.toString(),
              AppColors.primary,
              Icons.people,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          Expanded(
            child: _buildStatItem(
              'موثق',
              verifiedProviders.toString(),
              Colors.green,
              Icons.verified,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          Expanded(
            child: _buildStatItem(
              'مميز',
              featuredProviders.toString(),
              Colors.amber,
              Icons.star,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String title, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildProviderCard(ProviderProfile provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: provider.isFeatured
            ? Border.all(color: Colors.amber, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildProviderAvatar(provider),
          const SizedBox(width: 12),
          Expanded(child: _buildProviderInfo(provider)),
          _buildControlButtons(provider),
        ],
      ),
    );
  }

  Widget _buildProviderAvatar(ProviderProfile provider) {
    final imageUrl = provider.profileImageUrl ?? provider.profileImage;

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: imageUrl != null && imageUrl.isNotEmpty
          ? ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) => Icon(
            provider.getServiceIcon(),
            color: AppColors.primary,
            size: 24,
          ),
        ),
      )
          : Icon(
        provider.getServiceIcon(),
        color: AppColors.primary,
        size: 24,
      ),
    );
  }

  Widget _buildProviderInfo(ProviderProfile provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                provider.displayName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (provider.isVerified) ...[
              const SizedBox(width: 8),
              const Icon(Icons.verified, color: Colors.green, size: 16),
            ],
            if (provider.isFeatured) ...[
              const SizedBox(width: 8),
              const Icon(Icons.star, color: Colors.amber, size: 16),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${provider.categoryName ?? 'غير محدد'} • ${provider.city}',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
          ),
        ),
        if (provider.hasServices) ...[
          const SizedBox(height: 4),
          Text(
            'الخدمات: ${provider.totalServices}',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildControlButtons(ProviderProfile provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          height: 32,
          child: ElevatedButton(
            onPressed: () => _toggleVerification(provider),
            style: ElevatedButton.styleFrom(
              backgroundColor: provider.isVerified
                  ? Colors.red.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
              foregroundColor: provider.isVerified ? Colors.red : Colors.green,
              elevation: 0,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              provider.isVerified ? 'إلغاء' : 'توثيق',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 80,
          height: 32,
          child: ElevatedButton(
            onPressed: () => _toggleFeatured(provider),
            style: ElevatedButton.styleFrom(
              backgroundColor: provider.isFeatured
                  ? Colors.amber.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              foregroundColor: Colors.amber.shade700,
              elevation: 0,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              provider.isFeatured ? 'إزالة' : 'مميز',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _toggleVerification(ProviderProfile provider) async {
    final newStatus = !provider.isVerified;

    try {
      final success = await _adminService.updateProviderVerification(
        provider.id.toString(),
        newStatus,
      );

      if (success && mounted) {
        setState(() {
          final index = _allProviders.indexWhere((p) => p.id == provider.id);
          if (index != -1) {
            _allProviders[index] = provider.copyWith(isVerified: newStatus);
          }
        });

        _showSuccessSnackbar(
          newStatus
              ? 'تم توثيق ${provider.displayName}'
              : 'تم إلغاء توثيق ${provider.displayName}',
          newStatus ? Colors.green : Colors.red,
        );
      } else if (mounted) {
        _showErrorSnackbar('حدث خطأ أثناء تحديث حالة التوثيق');
      }
    } catch (e) {
      print('خطأ في تبديل التوثيق: $e');
      if (mounted) {
        _showErrorSnackbar('حدث خطأ أثناء تحديث حالة التوثيق');
      }
    }
  }

  void _toggleFeatured(ProviderProfile provider) async {
    final newStatus = !provider.isFeatured;

    try {
      final success = await _adminService.updateProviderFeatured(
        provider.id.toString(),
        newStatus,
      );

      if (success && mounted) {
        setState(() {
          final index = _allProviders.indexWhere((p) => p.id == provider.id);
          if (index != -1) {
            _allProviders[index] = provider.copyWith(isFeatured: newStatus);
          }
        });

        _showSuccessSnackbar(
          newStatus
              ? 'تم إضافة ${provider.displayName} للمميزين'
              : 'تم إزالة ${provider.displayName} من المميزين',
          newStatus ? Colors.amber : Colors.orange,
        );
      } else if (mounted) {
        _showErrorSnackbar('حدث خطأ أثناء تحديث حالة المميز');
      }
    } catch (e) {
      print('خطأ في تبديل المميز: $e');
      if (mounted) {
        _showErrorSnackbar('حدث خطأ أثناء تحديث حالة المميز');
      }
    }
  }

  void _showSuccessSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}