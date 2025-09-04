// lib/features/admin/screens/simple_admin_screen.dart
import 'package:flutter/material.dart';
import 'package:service_hub/features/auth/services/auth_service.dart';
import 'package:service_hub/features/service_provider/models/provider_profile.dart';
import 'package:service_hub/features/service_provider/services/provider_service.dart';
import 'package:service_hub/models/service.dart';
import 'package:service_hub/models/category.dart';
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
  List<Category> _categories = [];
  bool _isLoading = true;

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
      final providers = await providerService.getAllProvidersAdmin();
      final categories = await ServicesApiService.getAllCategories();

      setState(() {
        _allProviders = providers;
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      print('خطأ في تحميل البيانات: $e');
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
            Tab(text: 'الفئات'),
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
                _buildCategoriesTab(),
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
              border: provider.isFeatured
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
                              color: Colors.blue,
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
                          backgroundColor: provider.isFeatured
                              ? AppColors.accent.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.1),
                          foregroundColor: AppColors.accent,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          provider.isFeatured ? 'إزالة مميز' : 'جعل مميز',
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
            color: Colors.white,
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
            color: Colors.white,
            size: 24,
          ),
        ),
      );
    } else {
      return Icon(
        provider.getServiceIcon(),
        color: Colors.white,
        size: 24,
      );
    }
  }

  Widget _buildCategoriesTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length + 1,
        itemBuilder: (context, index) {
          // زر إضافة فئة جديدة
          if (index == _categories.length) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _showAddCategoryDialog,
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
                          'إضافة فئة جديدة',
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

          final category = _categories[index];
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
                        '${category.servicesCount ?? 0} خدمة',
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
                  onPressed: () => _deleteCategory(category),
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  tooltip: 'حذف الفئة',
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
          backgroundColor: provider.isFeatured ? Colors.orange : AppColors.accent,
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

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة فئة جديدة'),
        content: SizedBox(
          width: double.maxFinite,
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'اسم الفئة',
              hintText: 'مثال: خدمات التصوير',
              border: OutlineInputBorder(),
            ),
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
                _addNewCategory(nameController.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _addNewCategory(String name) async {
    final success = await _adminService.createServiceCategory(name);

    if (success) {
      await _loadData(); // إعادة تحميل البيانات

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إضافة فئة "$name"'),
          backgroundColor: AppColors.secondary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء إضافة الفئة'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteCategory(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف فئة "${category.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final success = await _adminService.deleteServiceCategory(category.id.toString());

              if (success) {
                setState(() {
                  _categories.removeWhere((c) => c.id == category.id);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم حذف "${category.name}"'),
                    backgroundColor: Colors.red,
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