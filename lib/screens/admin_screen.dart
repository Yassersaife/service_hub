// lib/features/admin/screens/simple_admin_screen.dart
import 'package:flutter/material.dart';
import 'package:service_hub/features/auth/services/auth_service.dart';
import 'package:service_hub/features/service_provider/models/provider_profile.dart';
import 'package:service_hub/features/service_provider/services/provider_service.dart';
import 'package:service_hub/models/service_models.dart';
import 'package:service_hub/screens/welcome_screen.dart';
import 'package:service_hub/services/services_api_service.dart';
import '../../../core/utils/app_colors.dart';
import '../services/admin_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<ProviderProfile> _allProviders = [];
  List<ServiceCategory> _serviceCategories = [];
  bool _isLoading = true;

  List<String> _featuredProviders = [];

  final _adminService = AdminService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final providerService = ProviderService();
      final providers = await providerService.getAllProvidersadmin();
      final categories = await ServicesApiService.getAllServiceCategories();

      setState(() {
        _allProviders = providers;
        _serviceCategories = categories;
        _isLoading = false;
        print('-===============');
        print(_allProviders);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'إدارة النظام',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _handleLogout,
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            tooltip: 'تسجيل الخروج',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'مقدمي الخدمات'),
            Tab(text: 'الخدمات'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // إحصائيات بسيطة
          _buildQuickStats(),

          // محتوى التبويبات
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProvidersTab(),
                _buildServicesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final totalProviders = _allProviders.length;
    final verifiedProviders = _allProviders.where((p) => p.isVerified).length;
    final featuredProviders = _allProviders.where((p) => p.isfeatured).length;

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
              AppColors.secondary,
              Icons.verified,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          Expanded(
            child: _buildStatItem(
              'مميز',
              featuredProviders.toString(),
              AppColors.accent,
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

  Widget _buildProvidersTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _allProviders.length,
        itemBuilder: (context, index) {
          final provider = _allProviders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: provider.isfeatured
                  ? Border.all(color: AppColors.accent, width: 2)
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
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        provider.getServiceColor(),
                        provider.getServiceColor().withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: provider.profileImage != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      provider.profileImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(
                            provider.getServiceIcon(),
                            color: Colors.white,
                            size: 24,
                          ),
                    ),
                  )
                      : Icon(
                    provider.getServiceIcon(),
                    color: Colors.white,
                    size: 24,
                  ),
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
                              provider.name ?? 'مقدم الخدمة',
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
                              color: Colors.blue,
                              size: 16,
                            ),
                          ],
                          if (provider.isfeatured) ...[
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
                        '${provider.getServiceLabel()} • ${provider.city}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                Column(
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
                              : AppColors.secondary.withOpacity(0.1),
                          foregroundColor: provider.isVerified
                              ? Colors.red
                              : AppColors.secondary,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          provider.isVerified ? 'إلغاء توثيق' : 'توثيق',
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
                          backgroundColor: provider.isfeatured
                              ? AppColors.accent.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.1),
                          foregroundColor: AppColors.accent,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          provider.isfeatured ? 'إزالة مميز' : 'جعل مميز',
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
        },
      ),
    );
  }

  Widget _buildServicesTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _serviceCategories.length + 1,
        itemBuilder: (context, index) {
          // زر إضافة خدمة جديدة
          if (index == _serviceCategories.length) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _showAddServiceDialog,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: AppColors.primary,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'إضافة خدمة جديدة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          final category = _serviceCategories[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
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
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: category.getLinearGradient(),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    category.getCategoryIcon(),
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${category.servicesCount} تخصص',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                // زر حذف
                IconButton(
                  onPressed: () => _deleteServiceCategory(category),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  tooltip: 'حذف الخدمة',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // API functions
  void _toggleVerification(ProviderProfile provider) async {
    final success = await _adminService.updateProviderVerification(
      provider.userId,
      !provider.isVerified,
    );

    if (success) {
      setState(() {
        final index = _allProviders.indexWhere((p) => p.userId == provider.userId);
        if (index != -1) {
          _allProviders[index] = provider.copyWith(isVerified: !provider.isVerified);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.isVerified
                ? 'تم إلغاء توثيق ${provider.name}'
                : 'تم توثيق ${provider.name}',
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
      provider.userId,
      !provider.isfeatured,
    );

    if (success) {
      setState(() {
        final index = _allProviders.indexWhere((p) => p.userId == provider.userId);
        if (index != -1) {
          _allProviders[index] =
              provider.copyWith(isfeatured: !provider.isfeatured);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.isfeatured
                ? 'تم إزالة ${provider.name} من المميزين'
                : 'تم إضافة ${provider.name} للمميزين',
          ),
          backgroundColor: provider.isfeatured ? Colors.orange : AppColors.accent,
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

  void _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('تسجيل الخروج', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await AuthService.logout();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    }
  }

  void _showAddServiceDialog() {
    final nameController = TextEditingController();
    final specialtiesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة خدمة جديدة'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم الخدمة',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: specialtiesController,
                decoration: const InputDecoration(
                  labelText: 'التخصصات (فصل بفاصلة)',
                  hintText: 'مثال: تصوير أفراح, تصوير منتجات, تصوير شخصي',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                _addNewServiceCategory(
                  nameController.text.trim(),
                  specialtiesController.text.trim(),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _addNewServiceCategory(String name, String specialtiesText) async {
    final specialties = specialtiesText
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final success = await _adminService.createServiceCategory(name, specialties);

    if (success) {
      setState(() {
        final newCategory = ServiceCategory(
          id: DateTime.now().millisecondsSinceEpoch,
          name: name,
          nameEn: name.toLowerCase().replaceAll(' ', '-'),
          slug: name.toLowerCase().replaceAll(' ', '-'),
          icon: 'category',
          color: '#3B82F6',
          gradientColors: ['#3B82F6', '#1E40AF'],
          description: name,
          isActive: true,
          sortOrder: _serviceCategories.length + 1,
          services: specialties.map((specialty) => Service(
            id: DateTime.now().millisecondsSinceEpoch,
            name: specialty,
            nameEn: specialty.toLowerCase().replaceAll(' ', '-'),
            slug: specialty.toLowerCase().replaceAll(' ', '-'),
            description: specialty,
            isActive: true,
            sortOrder: 1,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          )).toList(),
          servicesCount: specialties.length,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        _serviceCategories.add(newCategory);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إضافة خدمة "$name" مع ${specialties.length} تخصص'),
          backgroundColor: AppColors.secondary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء إضافة الخدمة'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteServiceCategory(ServiceCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف خدمة "${category.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final success = await _adminService.deleteServiceCategory(category.id);

              if (success) {
                setState(() {
                  _serviceCategories.removeWhere((c) => c.id == category.id);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم حذف "${category.name}"'),
                    backgroundColor: Colors.red,
                    action: SnackBarAction(
                      label: 'تراجع',
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          _serviceCategories.add(category);
                        });
                      },
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('حدث خطأ أثناء الحذف'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}