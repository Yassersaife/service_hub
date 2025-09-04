import 'package:flutter/material.dart';
import 'package:service_hub/core/utils/app_colors.dart';
import 'package:service_hub/features/auth/services/auth_service.dart';
import 'package:service_hub/features/service_provider/models/profile_setup_data.dart';
import 'package:service_hub/features/service_provider/models/provider_profile.dart';
import 'package:service_hub/features/service_provider/services/provider_service.dart';
import 'package:service_hub/features/service_provider/widgets/profile_progress_indicator.dart';
import 'package:service_hub/features/service_provider/widgets/profile_setup_basic_info.dart';
import 'package:service_hub/models/category.dart';
import 'package:service_hub/features/service_provider/widgets/profile_setup_portfolio.dart';
import 'package:service_hub/features/service_provider/widgets/profile_setup_contact.dart';

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

  final ProfileSetupData _data = ProfileSetupData();

  bool _isLoading = false;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    if (widget.existingProfile != null) {
      _loadExistingData();
    }
  }

  void _loadExistingData() {
    final profile = widget.existingProfile!;
    _data.selectedCategoryId = profile.categoryId?.toString();
    _data.selectedCity = profile.city;
    _data.description = profile.description ?? '';
    _data.whatsappNumber = profile.whatsappNumber ?? '';
    _data.workHours = profile.workHours ?? '';
    _data.address = profile.address ?? '';
    _data.profileImagePath = profile.profileImageUrl ?? profile.profileImage;
    _data.portfolioImages = profile.allPortfolioImages;
    _data.socialMedia = Map.from(profile.socialMedia ?? {});
  }

  @override
  void dispose() {
    _tabController.dispose();
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
            child: ProfileProgressIndicator(currentStep: _currentStep),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ProfileSetupBasicInfo(
            data: _data,
            onDataChanged: () => setState(() {}),
          ),
          ProfileSetupPortfolio(
            data: _data,
            onDataChanged: () => setState(() {}),
          ),
          ProfileSetupContact(
            data: _data,
            onDataChanged: () => setState(() {}),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
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

  void _nextStep() {
    if (_currentStep == 0) {
      if (_data.selectedCategoryId == null ||
          _data.selectedCity == null ||
          _data.description.isEmpty) {
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
      final userId = user['id'] is int ? user['id'] : int.parse(user['id'].toString());

      final profile = ProviderProfile(
        id: widget.existingProfile?.id ?? 0,
        userId: userId,
        categoryId: _data.selectedCategoryId != null ? int.parse(_data.selectedCategoryId!) : null,
        city: _data.selectedCity!,
        address: _data.address.isNotEmpty ? _data.address : null,
        description: _data.description,
        profileImage: _data.profileImagePath,
        portfolioImages: _data.portfolioImages,
        workHours: _data.workHours.isNotEmpty ? _data.workHours : null,
        socialMedia: _data.socialMedia,
        whatsappNumber: _data.whatsappNumber.isNotEmpty ? _data.whatsappNumber : null,
        isVerified: widget.existingProfile?.isVerified ?? false,
        isFeatured: widget.existingProfile?.isFeatured ?? false,
        isComplete: true,
        createdAt: widget.existingProfile?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
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
