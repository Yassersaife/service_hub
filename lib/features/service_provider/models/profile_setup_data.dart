class ProfileSetupData {
  // المعلومات الأساسية
  String? selectedCategoryId;
  String? selectedCity;
  String address = '';
  String description = '';
  String workHours = '';

  // معلومات التواصل
  String whatsappNumber = '';
  Map<String, String> socialMedia = {};

  // الصور
  String? profileImagePath;
  List<String> portfolioImages = [];

  // التخصصات/الخدمات - إصلاح المشكلة
  List<String> selectedServiceIds = [];
  List<String> selectedServiceNames = [];

  ProfileSetupData();

  // Constructor لتحميل البيانات الموجودة - محسن
  ProfileSetupData.fromExistingProfile({
    String? categoryId,
    String? city,
    String? existingAddress,
    String? existingDescription,
    String? existingWorkHours,
    String? existingWhatsapp,
    Map<String, dynamic>? existingSocialMedia,
    String? existingProfileImage,
    List<String>? existingPortfolioImages,
    List<Map<String, dynamic>>? existingServices,
  }) {
    selectedCategoryId = categoryId;
    selectedCity = city;
    address = existingAddress ?? '';
    description = existingDescription ?? '';
    workHours = existingWorkHours ?? '';
    whatsappNumber = existingWhatsapp ?? '';

    // إصلاح تحويل social media
    if (existingSocialMedia != null) {
      socialMedia = {};
      existingSocialMedia.forEach((key, value) {
        if (value != null) {
          socialMedia[key] = value.toString();
        }
      });
    }

    profileImagePath = existingProfileImage;
    portfolioImages = List<String>.from(existingPortfolioImages ?? []);

    // إصلاح تحميل التخصصات المحفوظة
    if (existingServices != null && existingServices.isNotEmpty) {
      selectedServiceIds = [];
      selectedServiceNames = [];

      for (var service in existingServices) {
        if (service['id'] != null && service['name'] != null) {
          selectedServiceIds.add(service['id'].toString());
          selectedServiceNames.add(service['name'].toString());
        }
      }

      print('تم تحميل التخصصات: $selectedServiceNames');
      print('IDs: $selectedServiceIds');
    }
  }

  // إضافة متغيرات للتحكم في حالة التحديث
  bool get isUpdating => selectedServiceIds.isNotEmpty || portfolioImages.isNotEmpty;

  // دالة لإضافة خدمة
  void addService(String serviceId, String serviceName) {
    if (!selectedServiceIds.contains(serviceId)) {
      selectedServiceIds.add(serviceId);
      selectedServiceNames.add(serviceName);
    }
  }

  // دالة لحذف خدمة
  void removeService(String serviceId) {
    int index = selectedServiceIds.indexOf(serviceId);
    if (index != -1) {
      selectedServiceIds.removeAt(index);
      if (index < selectedServiceNames.length) {
        selectedServiceNames.removeAt(index);
      }
    }
  }

  // دالة لتحديث قائمة الخدمات
  void updateServices(List<String> serviceIds, List<String> serviceNames) {
    selectedServiceIds = List<String>.from(serviceIds);
    selectedServiceNames = List<String>.from(serviceNames);
  }

  // التحقق من اكتمال البيانات المطلوبة
  bool get isBasicInfoComplete {
    return selectedCategoryId != null &&
        selectedCity != null &&
        description.isNotEmpty;
  }

  // تنظيف البيانات الفارغة
  void cleanEmptyData() {
    if (address.trim().isEmpty) address = '';
    if (workHours.trim().isEmpty) workHours = '';
    if (whatsappNumber.trim().isEmpty) whatsappNumber = '';

    // إزالة الروابط الفارغة من وسائل التواصل
    socialMedia.removeWhere((key, value) => value.trim().isEmpty);

    // تنظيف قوائم الخدمات من القيم الفارغة
    selectedServiceIds.removeWhere((id) => id.trim().isEmpty);
    selectedServiceNames.removeWhere((name) => name.trim().isEmpty);
  }

  @override
  String toString() {
    return 'ProfileSetupData('
        'categoryId: $selectedCategoryId, '
        'city: $selectedCity, '
        'hasDescription: ${description.isNotEmpty}, '
        'servicesCount: ${selectedServiceIds.length}, '
        'services: $selectedServiceNames, '
        'hasImages: ${portfolioImages.length}'
        ')';
  }
}