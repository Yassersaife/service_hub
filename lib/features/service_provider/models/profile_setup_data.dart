// lib/features/service_provider/models/profile_setup_data.dart

import 'package:Lumixy/models/service.dart';
import 'portfolio_image.dart';

class ProfileSetupData {
  String? selectedCategoryId;
  String? selectedCity;
  String address = '';
  String description = '';
  String workHours = '';

  String whatsappNumber = '';
  Map<String, String> socialMedia = {};

  String? profileImagePath;
  List<String> portfolioImages = [];
  List<PortfolioImage> existingPortfolioImages = [];

  List<int> selectedServiceIds = [];
  List<String> selectedServiceNames = [];

  ProfileSetupData();

  ProfileSetupData.fromExistingProfile({
    String? categoryId,
    String? city,
    String? existingAddress,
    String? existingDescription,
    String? existingWorkHours,
    String? existingWhatsapp,
    Map<String, dynamic>? existingSocialMedia,
    String? existingProfileImage,
    List<PortfolioImage>? existingPortfolio,
    List<Service>? existingServices,
  }) {
    selectedCategoryId = categoryId;
    selectedCity = city;
    address = existingAddress ?? '';
    description = existingDescription ?? '';
    workHours = existingWorkHours ?? '';
    whatsappNumber = existingWhatsapp ?? '';

    if (existingSocialMedia != null) {
      socialMedia = {};
      existingSocialMedia.forEach((key, value) {
        if (value != null) {
          socialMedia[key] = value.toString();
        }
      });
    }

    profileImagePath = existingProfileImage;

    if (existingPortfolio != null && existingPortfolio.isNotEmpty) {
      existingPortfolioImages = List<PortfolioImage>.from(existingPortfolio);
      print('تم تحميل ${existingPortfolioImages.length} صورة من المعرض');
    }

    // ✨ تحديث: استخدام Service objects مباشرة
    if (existingServices != null && existingServices.isNotEmpty) {
      selectedServiceIds = existingServices.map((s) => s.id).toList();
      selectedServiceNames = existingServices.map((s) => s.name).toList();
      print('تم تحميل التخصصات: $selectedServiceNames');
    }
  }

  List<String> getAllPortfolioImagePaths() {
    List<String> allPaths = [];
    allPaths.addAll(existingPortfolioImages.map((img) => img.imageUrl));
    allPaths.addAll(portfolioImages);
    return allPaths;
  }

  void removeExistingPortfolioImage(int imageId) {
    existingPortfolioImages.removeWhere((img) => img.id == imageId);
  }

  void removeNewPortfolioImage(String path) {
    portfolioImages.remove(path);
  }

  int get totalPortfolioCount =>
      existingPortfolioImages.length + portfolioImages.length;

  bool get isBasicInfoComplete {
    return selectedCategoryId != null &&
        selectedCity != null &&
        description.isNotEmpty;
  }

  // ✨ جديد: التحقق من اكتمال البيانات بشكل أفضل
  bool get isServicesSelected => selectedServiceIds.isNotEmpty;

  bool get hasPortfolioImages => totalPortfolioCount > 0;

  // ✨ جديد: الحصول على service IDs كـ Strings للـ API
  List<String> get serviceIdsAsStrings =>
      selectedServiceIds.map((id) => id.toString()).toList();

  void cleanEmptyData() {
    if (address.trim().isEmpty) address = '';
    if (workHours.trim().isEmpty) workHours = '';
    if (whatsappNumber.trim().isEmpty) whatsappNumber = '';

    socialMedia.removeWhere((key, value) => value.trim().isEmpty);
    selectedServiceNames.removeWhere((name) => name.trim().isEmpty);
  }

  // ✨ جديد: إضافة/إزالة خدمة
  void addService(Service service) {
    if (!selectedServiceIds.contains(service.id)) {
      selectedServiceIds.add(service.id);
      selectedServiceNames.add(service.name);
    }
  }

  void removeService(int serviceId) {
    final index = selectedServiceIds.indexOf(serviceId);
    if (index != -1) {
      selectedServiceIds.removeAt(index);
      selectedServiceNames.removeAt(index);
    }
  }

  void toggleService(Service service) {
    if (selectedServiceIds.contains(service.id)) {
      removeService(service.id);
    } else {
      addService(service);
    }
  }

  bool isServiceSelected(int serviceId) {
    return selectedServiceIds.contains(serviceId);
  }

  void clearServices() {
    selectedServiceIds.clear();
    selectedServiceNames.clear();
  }

  @override
  String toString() {
    return 'ProfileSetupData('
        'categoryId: $selectedCategoryId, '
        'city: $selectedCity, '
        'services: $selectedServiceNames, '
        'portfolioCount: $totalPortfolioCount'
        ')';
  }
}