import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Lumixy/core/utils/app_colors.dart';
import 'package:Lumixy/core/network/api_client.dart';
import 'package:Lumixy/models/category.dart';
import 'package:Lumixy/models/service.dart';
import 'package:Lumixy/widgets/custom_dropdown.dart';
import 'package:Lumixy/widgets/custom_multiselect.dart';
import 'package:Lumixy/widgets/custom_text_field.dart';
import 'package:Lumixy/features/service_provider/models/profile_setup_data.dart';
import 'profile_step_header.dart';
import 'package:Lumixy/services/services_api_service.dart';

class ProfileSetupBasicInfo extends StatefulWidget {
  final ProfileSetupData data;
  final VoidCallback onDataChanged;

  const ProfileSetupBasicInfo({
    super.key,
    required this.data,
    required this.onDataChanged,
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

  List<Service> _availableServices = [];
  List<String> _availableServiceNames = [];
  List<String> _selectedServiceNames = [];
  List<String> _selectedServiceIds = [];
  bool _loadingServices = false;

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

    _selectedServiceIds = widget.data.selectedServiceIds ?? [];
    _selectedServiceNames = widget.data.selectedServiceNames ?? [];
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
      print('Error loading categories: $e');
      setState(() {
        _availableCategories = [];
        _loadingCategories = false;
      });
    }
  }

  Future<void> _loadServicesByCategory(String categoryId) async {
    setState(() => _loadingServices = true);
    try {
      final services = await ServicesApiService.getAllServices(categoryId: categoryId);
      setState(() {
        _availableServices = services;
        _availableServiceNames = services.map((s) => s.name).toList();
        _loadingServices = false;
      });
    } catch (e) {
      print('Error loading services: $e');
      setState(() {
        _availableServices = [];
        _availableServiceNames = [];
        _loadingServices = false;
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

          _buildServicesMultiSelect(),

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
            required: true,
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
            const Text('فئة الخدمة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
            const Text(' *', style: TextStyle(color: AppColors.error, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
          ),
          child: DropdownButtonFormField<String>(
            value: widget.data.selectedCategoryId,
            hint: _loadingCategories
                ? const Row(children: [SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)), SizedBox(width: 8), Text('جاري تحميل الفئات...')])
                : const Text('اختر فئة خدمتك'),
            decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16)),
            items: _loadingCategories ? [] : _availableCategories.map((c) => DropdownMenuItem(value: c.id.toString(), child: Text(c.name))).toList(),
            onChanged: _loadingCategories ? null : (value) {
              widget.data.selectedCategoryId = value;
              widget.onDataChanged();
              if (value != null) {
                _loadServicesByCategory(value);
                _selectedServiceNames = [];
                _selectedServiceIds = [];
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServicesMultiSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _loadingServices
            ? const Center(child: CircularProgressIndicator())
            : CustomMultiSelect(
          label: 'التخصصات',
          items: _availableServiceNames,
          selectedItems: _selectedServiceNames,
          onSelectionChanged: (selectedNames) {
            setState(() {
              _selectedServiceNames = selectedNames;
              _selectedServiceIds = _availableServices
                  .where((s) => selectedNames.contains(s.name))
                  .map((s) => s.id.toString())
                  .toList();

              widget.data.selectedServiceIds = _selectedServiceIds;
              widget.data.selectedServiceNames = _selectedServiceNames;
              widget.onDataChanged();
            });
          },
        ),
      ],
    );
  }

  Widget _buildProfileImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('صورة البروفايل', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
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
                border: Border.all(color: Colors.grey.shade300, width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: widget.data.profileImagePath != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: widget.data.profileImagePath!.startsWith('http')
                    ? Image.network(widget.data.profileImagePath!, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar())
                    : Image.asset(widget.data.profileImagePath!, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar()),
              )
                  : _buildDefaultAvatar(),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(child: Text('اضغط لتغيير الصورة', style: TextStyle(fontSize: 12, color: Color(0xFF64748B)))),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo, color: Colors.grey.shade400, size: 40),
        const SizedBox(height: 8),
        Text('أضف صورة', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  void _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, maxWidth: 512, maxHeight: 512, imageQuality: 80);
    if (image != null) {
      widget.data.profileImagePath = image.path;
      widget.onDataChanged();
    }
  }
}
