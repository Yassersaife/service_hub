// lib/screens/admin/tabs/categories_tab.dart
import 'package:flutter/material.dart';
import 'package:service_hub/models/category.dart';
import 'package:service_hub/services/services_api_service.dart';
import 'package:service_hub/services/admin_service.dart';
import '../../../core/utils/app_colors.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  List<Category> _categories = [];
  bool _isLoading = true;
  final _adminService = AdminService();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final categories = await ServicesApiService.getAllCategories();

      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      print('خطأ في تحميل الفئات: $e');
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

    return RefreshIndicator(
      onRefresh: _loadCategories,
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
          return _buildCategoryCard(category);
        },
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
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

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // زر تعديل
              IconButton(
                onPressed: () => _showEditCategoryDialog(category),
                icon: const Icon(Icons.edit, size: 20),
                color: AppColors.primary,
                tooltip: 'تعديل',
              ),
              // زر حذف
              IconButton(
                onPressed: () => _deleteCategory(category),
                icon: const Icon(Icons.delete, size: 20),
                color: Colors.red,
                tooltip: 'حذف',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('إضافة', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(Category category) {
    final nameController = TextEditingController(text: category.name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تعديل الفئة'),
        content: SizedBox(
          width: double.maxFinite,
          child: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'اسم الفئة',
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
                _updateCategory(category.id.toString(), nameController.text.trim());
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('حفظ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _addNewCategory(String name) async {
    final success = await _adminService.createServiceCategory(name);

    if (success) {
      await _loadCategories();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إضافة فئة "$name"'),
          backgroundColor: Colors.green,
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

  void _updateCategory(String categoryId, String name) async {
    final success = await _adminService.updateServiceCategory(categoryId, name);

    if (success) {
      await _loadCategories();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تحديث الفئة إلى "$name"'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء تحديث الفئة'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteCategory(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف فئة "${category.name}"؟\nسيتم حذف جميع الخدمات المرتبطة بها.'),
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
                await _loadCategories();
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}