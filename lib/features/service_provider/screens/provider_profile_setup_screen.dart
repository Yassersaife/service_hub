// lib/features/service_provider/screens/provider_profile_setup_screen.dart

import 'package:Lumixy/models/service.dart';
import 'package:flutter/material.dart';
import 'package:Lumixy/core/utils/app_colors.dart';
import 'package:Lumixy/features/auth/services/auth_service.dart';
import 'package:Lumixy/features/service_provider/models/provider_profile.dart';
import 'package:Lumixy/features/service_provider/models/profile_setup_data.dart';
import 'package:Lumixy/features/service_provider/models/portfolio_image.dart';
import 'package:Lumixy/features/service_provider/services/provider_service.dart';
import 'package:Lumixy/features/service_provider/widgets/profile_progress_indicator.dart';
import 'package:Lumixy/features/service_provider/widgets/profile_setup_basic_info.dart';
import 'package:Lumixy/features/service_provider/widgets/profile_setup_contact.dart';
import 'package:Lumixy/features/service_provider/widgets/profile_setup_portfolio.dart';

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

  late ProfileSetupData _data;

  List<Service> _selectedServices = [];
  List<Service> _availableServices = [];

  bool _isLoading = false;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    if (widget.existingProfile != null) {
      _loadExistingData();
    } else {
      _data = ProfileSetupData();
    }
  }

  void _loadExistingData() {
    final profile = widget.existingProfile!;

    _data = ProfileSetupData.fromExistingProfile(
      categoryId: profile.categoryId?.toString(),
      city: profile.city,
      existingAddress: profile.address,
      existingDescription: profile.description,
      existingWorkHours: profile.workHours,
      existingWhatsapp: profile.whatsappNumber,
      existingSocialMedia: profile.socialMedia,
      existingProfileImage: profile.profileImageUrl ?? profile.profileImage,
      existingPortfolio: profile.portfolioImages,
      existingServices: profile.services, // ✅ الآن List<Service>
    );

    if (profile.services != null) {
      _selectedServices = List<Service>.from(profile.services!);
    }
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
            selectedServices: _selectedServices, // ✨ جديد
            onDataChanged: () => setState(() {}),
            onServicesChanged: (services) { // ✨ جديد
              setState(() {
                _selectedServices = services;
                _data.selectedServiceIds = services.map((s) => s.id).toList();
                _data.selectedServiceNames = services.map((s) => s.name).toList();
              });
            },
          ),
          ProfileSetupPortfolio(
            data: _data,
            onDataChanged: () => setState(() {}),
            onImageDeleted: _handleImageDeletion, // ✨ جديد
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

  // ✨ جديد: معالجة حذف الصور
  Future<void> _handleImageDeletion(int imageId) async {
    try {
      setState(() => _isLoading = true);

      final success = await _providerService.deletePortfolioImage(imageId);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حذف الصورة بنجاح'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // إزالة الصورة من البيانات المحلية
        setState(() {
          _data.removeExistingPortfolioImage(imageId);
        });
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('فشل حذف الصورة'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ خطأ في حذف الصورة: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
    // ✨ تحسين: Validation أفضل
    if (_currentStep == 0) {
      // التحقق من البيانات الأساسية
      if (_data.selectedCategoryId == null || _data.selectedCity == null) {
        _showError('يرجى اختيار التصنيف والمدينة');
        return;
      }

      if (_data.description.trim().isEmpty) {
        _showError('يرجى إضافة وصف للملف الشخصي');
        return;
      }

      // ✨ جديد: التحقق من اختيار خدمة واحدة على الأقل
      if (_selectedServices.isEmpty) {
        _showError('يرجى اختيار خدمة واحدة على الأقل');
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

      // ✨ تحديث: استخدام Service objects مباشرة
      List<Service>? servicesData = _selectedServices.isNotEmpty
          ? List<Service>.from(_selectedServices)
          : null;

      // ✨ تحسين: معالجة صور المعرض
      List<PortfolioImage>? portfolioImagesData;

      if (widget.existingProfile != null) {
        // في حالة التحديث: الصور الموجودة + الصور الجديدة
        portfolioImagesData = [];

        // إضافة الصور الموجودة (لم يتم حذفها)
        portfolioImagesData.addAll(_data.existingPortfolioImages);

        // إضافة الصور الجديدة
        for (var newImagePath in _data.portfolioImages) {
          portfolioImagesData.add(PortfolioImage(
            id: 0, // ID مؤقت للصور الجديدة
            imagePath: newImagePath,
            imageUrl: newImagePath,
          ));
        }

      } else {
        portfolioImagesData = _data.portfolioImages.map((path) {
          return PortfolioImage(
            id: 0,
            imagePath: path,
            imageUrl: path,
          );
        }).toList();
      }

      final profile = ProviderProfile(
        id: widget.existingProfile?.id ?? 0,
        userId: userId,
        categoryId: _data.selectedCategoryId != null
            ? int.parse(_data.selectedCategoryId!)
            : null,
        city: _data.selectedCity!,
        address: _data.address.isNotEmpty ? _data.address : null,
        description: _data.description.isNotEmpty ? _data.description : null,
        profileImage: _data.profileImagePath,
        portfolioImages: portfolioImagesData,
        workHours: _data.workHours.isNotEmpty ? _data.workHours : null,
        socialMedia: _data.socialMedia.isNotEmpty ? _data.socialMedia : null,
        whatsappNumber: _data.whatsappNumber.isNotEmpty ? _data.whatsappNumber : null,
        isVerified: widget.existingProfile?.isVerified ?? false,
        isFeatured: widget.existingProfile?.isFeatured ?? false,
        isComplete: true,
        createdAt: widget.existingProfile?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        services: servicesData, // ✅ الآن List<Service>
      );

      final success = await _providerService.saveProfile(profile);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text(widget.existingProfile != null
                    ? 'تم تحديث الملف الشخصي بنجاح'
                    : 'تم إنشاء الملف الشخصي بنجاح'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context, true);
      } else if (mounted) {
        _showError('فشل في حفظ الملف الشخصي');
      }
    } catch (e) {
      print('❌ خطأ في حفظ الملف الشخصي: $e');
      if (mounted) {
        _showError('حدث خطأ: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}