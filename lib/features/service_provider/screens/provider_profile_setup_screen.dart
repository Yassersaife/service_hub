import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_hub/core/utils/app_colors.dart';
import 'package:service_hub/features/auth/services/auth_service.dart';
import 'package:service_hub/widgets/custom_multiselect.dart';
import 'package:service_hub/widgets/custom_dropdown.dart';
import 'package:service_hub/widgets/custom_text_field.dart';
import 'package:service_hub/features/service_provider/services/provider_service.dart';
import 'package:service_hub/features/service_provider/models/provider_profile.dart';
import 'package:service_hub/core/network/api_client.dart';

class ProviderProfileSetupScreen extends StatefulWidget {
  final ProviderProfile? existingProfile;

  const ProviderProfileSetupScreen({super.key, this.existingProfile});

  @override
  State<ProviderProfileSetupScreen> createState() => _ProviderProfileSetupScreenState();
}

class _ProviderProfileSetupScreenState extends State<ProviderProfileSetupScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _providerService = ProviderService();

  // Form controllers
  final _descriptionController = TextEditingController();
  final _workHoursController = TextEditingController();
  final _addressController = TextEditingController();

  // Form data
  String? _selectedService;
  String? _selectedCity;
  String? _profileImagePath;
  List<String> _portfolioImages = [];
  List<String> _specialties = [];
  Map<String, String> _socialMedia = {};

  // API Data
  List<Category> _availableCategories = [];
  List<String> _availableSpecialties = [];
  bool _loadingCategories = false;
  bool _loadingSpecialties = false;

  bool _isLoading = false;
  int _currentStep = 0;

  final List<String> _cities = [
    "رام الله",
    "القدس",
    "بيت لحم",
    "الخليل",
    "نابلس",
    "جنين",
    "طولكرم",
    "قلقيلية",
    "سلفيت",
    "أريحا",
    "طوباس",
    "غزة",
    "الناصرة",
    "حيفا",
    "يافا",
    "عكا",
    "اللد",
    "الرملة",
    "سخنين",
    "أم الفحم",
    "رهط",
    "شفاعمرو",
    "طمرة",
  ];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCategories();

    if (widget.existingProfile != null) {
      _loadExistingData();
    }
  }

  Future<void> _loadCategories() async {
    setState(() {
      _loadingCategories = true;
    });

    try {
      final response = await ApiClient.get('/categories');

      if (response.success && response.data != null) {
        final categories = response.data as List;

        setState(() {
          _availableCategories = categories.map((category) => Category(
            id: category['id'].toString(),
            name: category['name'] ?? '',
            slug: category['slug'] ?? '',
          )).toList();
          _loadingCategories = false;
        });
      } else {
        setState(() {
          _availableCategories = [];
          _loadingCategories = false;
        });
      }
    } catch (e) {
      print('Error loading categories: $e');
      setState(() {
        _availableCategories = [];
        _loadingCategories = false;
      });
    }
  }

  Future<void> _loadSpecialtiesByService(String serviceSlug) async {
    setState(() {
      _loadingSpecialties = true;
      _availableSpecialties = [];
      _specialties = [];
    });

    try {
      final response = await ApiClient.get('/categories/$serviceSlug');

      if (response.success && response.data != null) {
        final data = response.data;
        final services = data['services'] as List?;

        if (services != null) {
          final specialties = services
              .map((service) => service['name']?.toString() ?? '')
              .where((name) => name.isNotEmpty)
              .toList();

          setState(() {
            _availableSpecialties = specialties;
            _loadingSpecialties = false;
          });
        } else {
          setState(() {
            _availableSpecialties = [];
            _loadingSpecialties = false;
          });
        }
      } else {
        setState(() {
          _availableSpecialties = [];
          _loadingSpecialties = false;
        });
      }
    } catch (e) {
      print('خطأ في تحميل التخصصات: $e');
      setState(() {
        _availableSpecialties = [];
        _loadingSpecialties = false;
      });
    }
  }

  void _loadExistingData() {
    final profile = widget.existingProfile!;
    _selectedService = profile.serviceType;
    _selectedCity = profile.city;
    _descriptionController.text = profile.description ?? '';
    _workHoursController.text = profile.workHours ?? '';
    _addressController.text = profile.address ?? '';
    _profileImagePath = profile.profileImage;
    _portfolioImages = List.from(profile.portfolioImages);
    _specialties = List.from(profile.specialties);
    _socialMedia = Map.from(profile.socialMedia ?? {});

    if (_selectedService != null) {
      _loadSpecialtiesByService(_selectedService!);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _descriptionController.dispose();
    _workHoursController.dispose();
    _addressController.dispose();
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
          'إعداد الملف الشخصي',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildProgressIndicator(),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildBasicInfoStep(),
          _buildPortfolioStep(),
          _buildContactStep(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
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
          ...List.generate(3, (index) {
            final isActive = index <= _currentStep;
            final isCompleted = index < _currentStep;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  if (index < 2) const SizedBox(width: 8),

                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.secondary
                          : isActive
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                          : Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  if (index < 2) const SizedBox(width: 8),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            'المعلومات الأساسية',
            'أضف المعلومات الأساسية عن خدمتك',
            Icons.info,
          ),

          const SizedBox(height: 24),

          _buildProfileImageSection(),

          const SizedBox(height: 24),

          _buildServiceDropdown(),

          const SizedBox(height: 20),

          CustomDropdown(
            label: 'المدينة',
            hint: 'اختر مدينتك',
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
            label: 'العنوان',
            hint: 'أدخل عنوانك التفصيلي',
            icon: Icons.location_on,
            controller: _addressController,
          ),

          const SizedBox(height: 20),

          CustomTextField(
            label: 'وصف الخدمة',
            hint: 'اكتب وصفاً مفصلاً عن خدمتك وخبرتك...',
            controller: _descriptionController,
            maxLines: 4,
            required: true,
          ),

          const SizedBox(height: 20),

          CustomTextField(
            label: 'ساعات العمل',
            hint: 'مثال: الأحد - الخميس: 9 صباحاً - 6 مساءً',
            icon: Icons.access_time,
            controller: _workHoursController,
          ),

          const SizedBox(height: 24),

          _buildSpecialtiesSection(),
        ],
      ),
    );
  }

  Widget _buildServiceDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'نوع الخدمة',
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
            value: _selectedService,
            hint: _loadingCategories
                ? const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('جاري تحميل الخدمات...'),
              ],
            )
                : const Text('اختر نوع خدمتك'),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: _loadingCategories ? [] : _availableCategories.map((Category category) {
              return DropdownMenuItem<String>(
                value: category.slug,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: _loadingCategories ? null : (value) {
              setState(() {
                _selectedService = value;
                _specialties.clear();
              });

              if (value != null) {
                _loadSpecialtiesByService(value);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialtiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedService == null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Text(
              'اختر نوع الخدمة أولاً لعرض التخصصات المتاحة',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          )
        else if (_loadingSpecialties)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_availableSpecialties.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text(
                'لا توجد تخصصات متاحة لهذه الخدمة',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else
            CustomMultiSelect(
              label: 'التخصصات',
              hint: 'اختر تخصصاتك',
              items: _availableSpecialties,
              selectedItems: _specialties,
              onSelectionChanged: (selectedItems) {
                setState(() {
                  _specialties = selectedItems;
                });
              },
            ),
      ],
    );
  }

  Widget _buildPortfolioStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            'معرض الأعمال',
            'أضف صوراً من أعمالك السابقة لجذب العملاء',
            Icons.photo_library,
          ),

          const SizedBox(height: 24),

          _buildAddPhotosButton(),

          const SizedBox(height: 20),

          if (_portfolioImages.isEmpty)
            _buildEmptyPortfolio()
          else
            _buildPortfolioGrid(),
        ],
      ),
    );
  }

  Widget _buildContactStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepHeader(
            'معلومات التواصل',
            'أضف روابط شبكاتك الاجتماعية (اختياري)',
            Icons.contact_page,
          ),

          const SizedBox(height: 24),

          _buildSocialMediaSection(),
        ],
      ),
    );
  }

  Widget _buildStepHeader(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
              child: _profileImagePath != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  _profileImagePath!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildDefaultAvatar(),
                ),
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

  Widget _buildAddPhotosButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _addPortfolioImages,
        icon: const Icon(Icons.add_photo_alternate),
        label: const Text('إضافة صور من أعمالك'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          side: BorderSide(color: AppColors.primary),
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
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
            'أضف صوراً من أعمالك لجذب العملاء',
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
      itemCount: _portfolioImages.length + 1,
      itemBuilder: (context, index) {
        if (index == _portfolioImages.length) {
          return GestureDetector(
            onTap: _addPortfolioImages,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.grey.shade600,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'إضافة',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

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
    final platforms = ['Instagram'];

    return Column(
      children: platforms.map((platform) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CustomTextField(
            label: platform,
            hint: 'اسم حسابك على $platform',
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

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: AppColors.primary),
                ),
                child: Text(
                  'السابق',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

          if (_currentStep > 0) const SizedBox(width: 16),

          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: _currentStep == 2
                    ? AppColors.secondaryGradient
                    : AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: (_currentStep == 2 ? AppColors.secondary : AppColors.primary)
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : (_currentStep == 2 ? _saveProfile : _nextStep),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  _currentStep == 2 ? 'حفظ الملف الشخصي' : 'التالي',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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

  void _addPortfolioImages() async {
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

  void _nextStep() {
    if (_currentStep == 0) {
      if (_selectedService == null ||
          _selectedCity == null ||
          _descriptionController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى ملء جميع الحقول المطلوبة'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    setState(() {
      _currentStep++;
    });

    _tabController.animateTo(_currentStep);
  }

  void _previousStep() {
    setState(() {
      _currentStep--;
    });

    _tabController.animateTo(_currentStep);
  }

  void _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = AuthService.currentUser!;

      final profile = ProviderProfile(
        userId: user['id'].toString(),
        name: user['name']?.toString(),
        serviceType: _selectedService!,
        city: _selectedCity!,
        address: _addressController.text.isNotEmpty ? _addressController.text : null,
        description: _descriptionController.text,
        profileImage: _profileImagePath,
        portfolioImages: _portfolioImages,
        workHours: _workHoursController.text.isNotEmpty ? _workHoursController.text : null,
        specialties: _specialties,
        socialMedia: _socialMedia,
        isComplete: false,
        joinDate: widget.existingProfile?.joinDate ?? DateTime.now(),
        rating: widget.existingProfile?.rating ?? 0.0,
        reviewsCount: widget.existingProfile?.reviewsCount ?? 0,
        isVerified: widget.existingProfile?.isVerified ?? false,
      );


      final success = await _providerService.saveProfile(profile);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ الملف الشخصي بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل في حفظ الملف الشخصي'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('خطأ في حفظ الملف الشخصي: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

class Category {
  final String id;
  final String name;
  final String slug;

  Category({
    required this.id,
    required this.name,
    required this.slug,
  });
}