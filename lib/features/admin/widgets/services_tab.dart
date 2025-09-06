// lib/screens/admin/tabs/services_tab.dart
import 'package:flutter/material.dart';
import 'package:service_hub/models/category.dart';
import 'package:service_hub/models/service.dart';
import 'package:service_hub/services/services_api_service.dart';
import 'package:service_hub/services/admin_service.dart';
import '../../../core/utils/app_colors.dart';

class ServicesTab extends StatefulWidget {
  const ServicesTab({super.key});

  @override
  State<ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends State<ServicesTab> {
  List<Category> _categories = [];
  List<Service> _services = [];
  bool _isLoading = true;
  final _adminService = AdminService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final categories = await ServicesApiService.getAllCategories();
      final services = await ServicesApiService.getAllServices();

      setState(() {
        _categories = categories;
        _services = services;
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // إحصائيات
        _buildServicesStats(),

        // قائمة الخدمات
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadData,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _categories.length + 1,
              itemBuilder: (context, index) {
                // زر إضافة خدمة جديدة
                if (index == _categories.length) {
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
                              color: Colors.green.withOpacity(0.3),
                              width: 2,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.work_outline,
                                color: Colors.green,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'إضافة خدمة جديدة',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
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
                final categoryServices = _services.where((service) => service.categoryId == category.id).toList();

                return _buildCategoryWithServices(category, categoryServices);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesStats() {
    final totalServices = _services.length;
    final categoriesWithServices = _categories.where((cat) =>
        _services.any((service) => service.categoryId == cat.id)).length;

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
              'إجمالي التخصصات',
              totalServices.toString(),
              Colors.blue,
              Icons.work,
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey.shade200),
          Expanded(
            child: _buildStatItem(
              'إجمالي الخدمات',
              categoriesWithServices.toString(),
              Colors.green,
              Icons.category,
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
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCategoryWithServices(Category category, List<Service> services) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: category.getLinearGradient(),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            category.getCategoryIcon(),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        subtitle: Text(
          '${services.length} خدمة',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF64748B),
          ),
        ),
        children: [
          if (services.isNotEmpty)
            ...services.map((service) => _buildServiceItem(service, category)),
          if (services.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'لا توجد خدمات في هذه الفئة',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(Service service, Category category) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: category.getPrimaryColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              service.getServiceIcon(),
              color: category.getPrimaryColor(),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  '${service.providersCount ?? 0} مقدم خدمة',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _showEditServiceDialog(service),
                icon: const Icon(Icons.edit, size: 18),
                color: Colors.blue,
                tooltip: 'تعديل',
              ),
              IconButton(
                onPressed: () => _deleteService(service),
                icon: const Icon(Icons.delete, size: 18),
                color: Colors.red,
                tooltip: 'حذف',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddServiceDialog() {
    final nameController = TextEditingController();
    Category? selectedCategory;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    hintText: 'مثال: تصوير المناسبات',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Category>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'الفئة',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (Category? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
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
                if (nameController.text.trim().isNotEmpty && selectedCategory != null) {
                  _addNewService(selectedCategory!.id.toString(), nameController.text.trim());
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('إضافة', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditServiceDialog(Service service) {
    final nameController = TextEditingController(text: service.name);
    Category? selectedCategory = _categories.firstWhere((cat) => cat.id == service.categoryId);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('تعديل الخدمة'),
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
                DropdownButtonFormField<Category>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'الفئة',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (Category? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
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
                if (nameController.text.trim().isNotEmpty && selectedCategory != null) {
                  _updateService(
                    service.id.toString(),
                    selectedCategory!.id.toString(),
                    nameController.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('حفظ', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewService(String categoryId, String name) async {
    final success = await _adminService.createService(
      categoryId: categoryId,
      name: name,
    );

    if (success) {
      await _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إضافة خدمة "$name"'),
          backgroundColor: Colors.green,
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

  void _updateService(String serviceId, String categoryId, String name) async {
    final success = await _adminService.updateService(
      serviceId: serviceId,
      categoryId: categoryId,
      name: name,
    );

    if (success) {
      await _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تحديث الخدمة إلى "$name"'),
          backgroundColor: Colors.blue,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ أثناء تحديث الخدمة'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteService(Service service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف خدمة "${service.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              final success = await _adminService.deleteService(service.id.toString());

              if (success) {
                await _loadData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم حذف "${service.name}"'),
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