
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
    List<String>? existingPortfolioImages,
  }) {
    selectedCategoryId = categoryId;
    selectedCity = city;
    address = existingAddress ?? '';
    description = existingDescription ?? '';
    workHours = existingWorkHours ?? '';
    whatsappNumber = existingWhatsapp ?? '';
    socialMedia = Map<String, String>.from(existingSocialMedia ?? {});
    profileImagePath = existingProfileImage;
    portfolioImages = List<String>.from(existingPortfolioImages ?? []);
  }

  bool get isBasicInfoComplete {
    return selectedCategoryId != null &&
        selectedCity != null &&
        description.isNotEmpty;
  }

  void cleanEmptyData() {
    if (address.trim().isEmpty) address = '';
    if (workHours.trim().isEmpty) workHours = '';
    if (whatsappNumber.trim().isEmpty) whatsappNumber = '';

    socialMedia.removeWhere((key, value) => value.trim().isEmpty);
  }

  @override
  String toString() {
    return 'ProfileSetupData('
        'categoryId: $selectedCategoryId, '
        'city: $selectedCity, '
        'hasDescription: ${description.isNotEmpty}, '
        'hasImages: ${portfolioImages.length}'
        ')';
  }
}