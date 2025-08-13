import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/service_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dropdown.dart';

class EditProfileScreen extends StatefulWidget {
  final ServiceProvider provider;

  const EditProfileScreen({super.key, required this.provider});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _workHoursController;

  // Variables
  String? _selectedService;
  String? _selectedCity;
  String? _profileImagePath;
  List<String> _portfolioImages = [];
  List<String> _specialties = [];
  Map<String, String> _socialMedia = {};

  final List<Map<String, String>> _serviceTypes = [
    {'value': 'photographer', 'label': 'مصور'},
    {'value': 'video-editor', 'label': 'مونتاج فيديوهات'},
    {'value': 'photo-editor', 'label': 'تعديل صور'},
    {'value': 'printer', 'label': 'طباعة صور'},
  ];

  final List<String> _cities = [
    'نابلس', 'رام الله', 'القدس', 'الخليل', 'بيت لحم', 'جنين', 'طولكرم'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // تهيئة المتحكمات بالبيانات الحالية
    _nameController = TextEditingController(text: widget.provider.name);
    _phoneController = TextEditingController(text: widget.provider.phone);
    _emailController = TextEditingController(text: widget.provider.email ?? '');
    _descriptionController = TextEditingController(text: widget.provider.description ?? '');
    _workHoursController = TextEditingController(text: widget.provider.workHours ?? '');

    _selectedService = widget.provider.service;
    _selectedCity = widget.provider.city;
    _profileImagePath = widget.provider.profileImage;
    _portfolioImages = List.from(widget.provider.portfolioImages);
    _specialties = List.from(widget.provider.specialties);
    _socialMedia = Map.from(widget.provider.socialMedia ?? {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _workHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'تعديل الملف الشخصي',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'حفظ',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'المعلومات الأساسية'),
            Tab(text: 'الأعمال'),
            Tab(text: 'التواصل'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBasicInfoTab(),
          _buildPortfolioTab(),
          _buildContactTab(),
        ],
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة البروفايل
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: _profileImagePath != null
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            _profileImagePath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildDefaultAvatar(),
                          ),
                        )
                            : _buildDefaultAvatar(),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickProfileImage,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اضغط لتغيير الصورة',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // المعلومات الأساسية
            CustomTextField(
              label: 'الاسم الكامل',
              hint: 'أدخل اسمك الكامل',
              icon: Icons.person,
              controller: _nameController,
              required: true,
            ),

            const SizedBox(height: 20),

            CustomDropdown(
              label: 'نوع الخدمة',
              hint: 'اختر نوع الخدمة',
              value: _selectedService,
              items: _serviceTypes.map((e) => e['value']!).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedService = value;
                });
              },
              required: true,
            ),

            const SizedBox(height: 20),

            CustomDropdown(
              label: 'المدينة',
              hint: 'اختر المدينة',
              value: _selectedCity,
              items: _cities,
              onChanged: (value) {
                setState(() {
                  _selectedCity = value;
                });
              },
              required: true,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              label: 'رقم الهاتف',
              hint: '05xxxxxxxx',
              icon: Icons.phone,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              required: true,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              label: 'البريد الإلكتروني',
              hint: 'example@email.com',
              icon: Icons.email,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              label: 'وصف الخدمة',
              hint: 'اكتب وصفاً مفصلاً عن خدمتك وخبرتك...',
              controller: _descriptionController,
              maxLines: 4,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              label: 'ساعات العمل',
              hint: 'مثال: الأحد - الخميس: 9 صباحاً - 6 مساءً',
              icon: Icons.access_time,
              controller: _workHoursController,
            ),

            const SizedBox(height: 24),

            // التخصصات
            _buildSpecialtiesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'معرض الأعمال',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _addPortfolioImage,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('إضافة صورة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (_portfolioImages.isEmpty)
            _buildEmptyPortfolio()
          else
            _buildPortfolioGrid(),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الشبكات الاجتماعية',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),

          const SizedBox(height: 16),

          _buildSocialMediaSection(),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        widget.provider.getServiceIcon(),
        color: AppColors.primary,
        size: 50,
      ),
    );
  }

  Widget _buildSpecialtiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'التخصصات',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            TextButton.icon(
              onPressed: _addSpecialty,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('إضافة'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        if (_specialties.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Text(
              'لم تتم إضافة تخصصات بعد',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _specialties.asMap().entries.map((entry) {
              final index = entry.key;
              final specialty = entry.value;

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      specialty,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _removeSpecialty(index),
                      child: Icon(
                        Icons.close,
                        size: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildEmptyPortfolio() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد أعمال بعد',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اضغط على "إضافة صورة" لعرض أعمالك',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: _portfolioImages.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _portfolioImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => _removePortfolioImage(index),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSocialMediaSection() {
    final platforms = ['Facebook', 'Instagram', 'Twitter', 'LinkedIn'];

    return Column(
      children: platforms.map((platform) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CustomTextField(
            label: platform,
            hint: 'رابط حسابك على $platform',
            icon: _getSocialIcon(platform),
            controller: TextEditingController(
              text: _socialMedia[platform.toLowerCase()] ?? '',
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                _socialMedia[platform.toLowerCase()] = value;
              } else {
                _socialMedia.remove(platform.toLowerCase());
              }
            },
          ),
        );
      }).toList(),
    );
  }

  IconData _getSocialIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return Icons.facebook;
      case 'instagram':
        return Icons.camera_alt;
      case 'twitter':
        return Icons.alternate_email;
      case 'linkedin':
        return Icons.work;
      default:
        return Icons.link;
    }
  }

  void _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _profileImagePath = image.path;
      });
    }
  }

  void _addPortfolioImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (images.isNotEmpty) {
      setState(() {
        _portfolioImages.addAll(images.map((image) => image.path));
      });
    }
  }

  void _removePortfolioImage(int index) {
    setState(() {
      _portfolioImages.removeAt(index);
    });
  }

  void _addSpecialty() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('إضافة تخصص'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'اكتب التخصص',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _specialties.add(controller.text);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('إضافة'),
            ),
          ],
        );
      },
    );
  }

  void _removeSpecialty(int index) {
    setState(() {
      _specialties.removeAt(index);
    });
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate() &&
        _nameController.text.isNotEmpty &&
        _selectedService != null &&
        _selectedCity != null &&
        _phoneController.text.isNotEmpty) {

      final updatedProvider = widget.provider.copyWith(
        name: _nameController.text,
        service: _selectedService!,
        city: _selectedCity!,
        phone: _phoneController.text,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        profileImage: _profileImagePath,
        portfolioImages: _portfolioImages,
        workHours: _workHoursController.text.isNotEmpty ? _workHoursController.text : null,
        specialties: _specialties,
        socialMedia: _socialMedia.isNotEmpty ? _socialMedia : null,
      );

      Navigator.pop(context, updatedProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ التغييرات بنجاح'),
          backgroundColor: AppColors.secondary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى ملء جميع الحقول المطلوبة'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}