import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:Lumixy/core/utils/app_colors.dart';
import 'package:Lumixy/models/category.dart';
import 'package:Lumixy/models/service.dart';
import 'package:Lumixy/widgets/custom_dropdown.dart';
import 'package:Lumixy/widgets/custom_text_field.dart';
import 'package:Lumixy/features/service_provider/models/profile_setup_data.dart';
import 'package:Lumixy/features/service_provider/widgets/service_selector_widget.dart';
import 'profile_step_header.dart';
import 'package:Lumixy/services/services_api_service.dart';

class ProfileSetupBasicInfo extends StatefulWidget {
  final ProfileSetupData data;
  final List<Service> selectedServices; // ✨ جديد
  final VoidCallback onDataChanged;
  final Function(List<Service>) onServicesChanged; // ✨ جديد

  const ProfileSetupBasicInfo({
    super.key,
    required this.data,
    required this.selectedServices, // ✨ جديد
    required this.onDataChanged,
    required this.onServicesChanged, // ✨ جديد
  });

  @override
  State<ProfileSetupBasicInfo> createState() => _ProfileSetupBasicInfoState();
}

class _ProfileSetupBasicInfoState extends State<ProfileSetupBasicInfo> {
  final _descriptionController = TextEditingController();
  final _workHoursController = TextEditingController();
  final _addressController = TextEditingController();

  List<Category> _availableCategories = [];
  bool _loadingCategories = false;

  final List<String> _cities = [
    "رام الله","القدس","بيت لحم","الخليل","نابلس","جنين","طولكرم","قلقيلية",
    "سلفيت","أريحا","طوباس","غزة","الناصرة","حيفا","يافا","عكا","اللد",
    "الرملة","سخنين","أم الفحم","رهط","شفاعمرو","طمرة",
  ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadExistingData();
  }

  void _loadExistingData() {
    _descriptionController.text = widget.data.description;
    _workHoursController.text = widget.data.workHours;
    _addressController.text = widget.data.address;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _workHoursController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() => _loadingCategories = true);
    try {
      final categories = await ServicesApiService.getAllCategories();
      setState(() {
        _availableCategories = categories;
        _loadingCategories = false;
      });
    } catch (e) {
      print('❌ خطأ في تحميل الفئات: $e');
      setState(() {
        _availableCategories = [];
        _loadingCategories = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileStepHeader(
            title: 'المعلومات الأساسية',
            subtitle: 'أضف المعلومات الأساسية عن خدمتك',
            icon: Icons.info,
          ),

          const SizedBox(height: 24),

          _buildProfileImageSection(),

          const SizedBox(height: 24),

          _buildCategoryDropdown(),

          const SizedBox(height: 20),

          ServiceSelectorWidget(
            categoryId: widget.data.selectedCategoryId != null
                ? int.tryParse(widget.data.selectedCategoryId!)
                : null,
            selectedServices: widget.selectedServices,
            onServicesChanged: widget.onServicesChanged,
            minServices: 1,
            maxServices: 10, // اختياري
          ),

          const SizedBox(height: 20),

          CustomDropdown(
            label: 'المدينة',
            hint: 'اختر مدينتك',
            value: widget.data.selectedCity,
            items: _cities,
            onChanged: (value) {
              widget.data.selectedCity = value;
              widget.onDataChanged();
            },
            required: true,
          ),

          const SizedBox(height: 20),

          CustomTextField(
            label: 'العنوان',
            hint: 'أدخل عنوانك التفصيلي',
            icon: Icons.location_on,
            controller: _addressController,
            onChanged: (value) {
              widget.data.address = value;
              widget.onDataChanged();
            },
          ),

          const SizedBox(height: 20),

          CustomTextField(
            label: 'وصف الخدمة',
            hint: 'اكتب وصفاً مفصلاً عن خدمتك وخبرتك...',
            controller: _descriptionController,
            maxLines: 4,
            required: false,
            onChanged: (value) {
              widget.data.description = value;
              widget.onDataChanged();
            },
          ),

          const SizedBox(height: 20),

          CustomTextField(
            label: 'ساعات العمل',
            hint: 'مثال: الأحد - الخميس: 9 صباحاً - 6 مساءً',
            icon: Icons.access_time,
            controller: _workHoursController,
            onChanged: (value) {
              widget.data.workHours = value;
              widget.onDataChanged();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'فئة الخدمة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const Text(
              ' *',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
              width: 2,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: widget.data.selectedCategoryId,
            hint: _loadingCategories
                ? const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('جاري تحميل الفئات...'),
              ],
            )
                : const Text('اختر فئة خدمتك'),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: _loadingCategories
                ? []
                : _availableCategories
                .map((c) => DropdownMenuItem(
              value: c.id.toString(),
              child: Text(c.name),
            ))
                .toList(),
            onChanged: _loadingCategories
                ? null
                : (value) {
              setState(() {
                widget.data.selectedCategoryId = value;
              });
              widget.onDataChanged();

              // ✨ مسح الخدمات المختارة عند تغيير الـ category
              if (value != null) {
                widget.onServicesChanged([]);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'صورة البروفايل',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: _pickProfileImage,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: widget.data.profileImagePath != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: _buildProfileImage(),
              )
                  : _buildDefaultAvatar(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'اضغط لتغيير الصورة',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
            ),
          ),
        ),
      ],
    );
  }

  // ✨ معالجة محسّنة لعرض الصورة
  Widget _buildProfileImage() {
    final imagePath = widget.data.profileImagePath!;

    // صورة من الإنترنت
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
      );
    }

    // صورة محلية (من الجهاز)
    try {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
      );
    } catch (e) {
      print('❌ خطأ في تحميل الصورة: $e');
      return _buildDefaultAvatar();
    }
  }

  Widget _buildDefaultAvatar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_a_photo,
          color: Colors.grey.shade400,
          size: 40,
        ),
        const SizedBox(height: 8),
        Text(
          'أضف صورة',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Future<void> _pickProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          widget.data.profileImagePath = image.path;
        });
        widget.onDataChanged();
      }
    } catch (e) {
      print('❌ خطأ في اختيار الصورة: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل اختيار الصورة'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}