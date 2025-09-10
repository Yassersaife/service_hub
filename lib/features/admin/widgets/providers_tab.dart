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
      final providerService = ProviderService();
      final providers = await providerService.getAllProvidersAdmin();

      setState(() {
        _allProviders = providers;
        _isLoading = false;
      });
    } catch (e) {
      print('خطأ في تحميل المقدمين: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // إحصائيات سريعة
        _buildQuickStats(),

        // قائمة المقدمين
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadProviders,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _allProviders.length,
              itemBuilder: (context, index) {
                final provider = _allProviders[index];
                return _buildProviderCard(provider);
              },
            ),
          ),
        ),
      ],
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
          // صورة المقدم
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: _buildProviderImage(provider),
          ),

          const SizedBox(width: 12),

          // معلومات المقدم
          Expanded(
            child: Column(
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
                      ),
                    ),
                    if (provider.isVerified) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: 16,
                      ),
                    ],
                    if (provider.isFeatured) ...[
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
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
              ],
            ),
          ),

          // أزرار التحكم
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // زر التوثيق
              SizedBox(
                width: 80,
                height: 32,
                child: ElevatedButton(
                  onPressed: () => _toggleVerification(provider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: provider.isVerified
                        ? Colors.red.withOpacity(0.1)
                        : Colors.green.withOpacity(0.1),
                    foregroundColor: provider.isVerified
                        ? Colors.red
                        : Colors.green,
                    elevation: 0,
                    padding: EdgeInsets.zero,
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

              // زر المميز
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
          ),
        ],
      ),
    );
  }

  Widget _buildProviderImage(ProviderProfile provider) {
    if (provider.profileImageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.network(
          provider.profileImageUrl!,
          fit: BoxFit.cover,
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) => Icon(
            provider.getServiceIcon(),
            color: AppColors.primary,
            size: 24,
          ),
        ),
      );
    } else if (provider.profileImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Image.network(
          provider.profileImage!,
          fit: BoxFit.cover,
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) => Icon(
            provider.getServiceIcon(),
            color: AppColors.primary,
            size: 24,
          ),
        ),
      );
    } else {
      return Icon(
        provider.getServiceIcon(),
        color: AppColors.primary,
        size: 24,
      );
    }
  }

  void _toggleVerification(ProviderProfile provider) async {
    final success = await _adminService.updateProviderVerification(
      provider.id.toString(),
      !provider.isVerified,
    );

    if (success) {
      setState(() {
        final index = _allProviders.indexWhere((p) => p.id == provider.id);
        if (index != -1) {
          _allProviders[index] = provider.copyWith(isVerified: !provider.isVerified);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.isVerified
                ? 'تم إلغاء توثيق ${provider.displayName}'
                : 'تم توثيق ${provider.displayName}',
          ),
          backgroundColor: provider.isVerified ? Colors.red : Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء تحديث حالة التوثيق'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleFeatured(ProviderProfile provider) async {
    final success = await _adminService.updateProviderFeatured(
      provider.id.toString(),
      !provider.isFeatured,
    );

    if (success) {
      setState(() {
        final index = _allProviders.indexWhere((p) => p.id == provider.id);
        if (index != -1) {
          _allProviders[index] = provider.copyWith(isFeatured: !provider.isFeatured);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.isFeatured
                ? 'تم إزالة ${provider.displayName} من المميزين'
                : 'تم إضافة ${provider.displayName} للمميزين',
          ),
          backgroundColor: provider.isFeatured ? Colors.orange : Colors.amber,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء تحديث حالة المميز'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}