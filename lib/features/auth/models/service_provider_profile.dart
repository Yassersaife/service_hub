
// lib/features/auth/models/service_provider_profile.dart
class ServiceProviderProfile {
  final String userId;
  final String serviceType;
  final String city;
  final String? description;
  final String? profileImage;
  final List<String> portfolioImages;
  final double rating;
  final int reviewsCount;
  final String? workHours;
  final Map<String, String>? socialMedia;
  final DateTime joinDate;
  final bool isVerified;
  final List<String> specialties;
  final bool isProfileComplete;

  ServiceProviderProfile({
    required this.userId,
    required this.serviceType,
    required this.city,
    this.description,
    this.profileImage,
    this.portfolioImages = const [],
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.workHours,
    this.socialMedia,
    DateTime? joinDate,
    this.isVerified = false,
    this.specialties = const [],
    this.isProfileComplete = false,
  }) : joinDate = joinDate ?? DateTime.now();

  String getServiceLabel() {
    switch (serviceType) {
      case 'photographer':
        return 'مصور';
      case 'video-editor':
        return 'مونتاج فيديوهات';
      case 'photo-editor':
        return 'تعديل صور';
      case 'printer':
        return 'طباعة صور';
      default:
        return serviceType;
    }
  }

  ServiceProviderProfile copyWith({
    String? userId,
    String? serviceType,
    String? city,
    String? description,
    String? profileImage,
    List<String>? portfolioImages,
    double? rating,
    int? reviewsCount,
    String? workHours,
    Map<String, String>? socialMedia,
    DateTime? joinDate,
    bool? isVerified,
    List<String>? specialties,
    bool? isProfileComplete,
  }) {
    return ServiceProviderProfile(
      userId: userId ?? this.userId,
      serviceType: serviceType ?? this.serviceType,
      city: city ?? this.city,
      description: description ?? this.description,
      profileImage: profileImage ?? this.profileImage,
      portfolioImages: portfolioImages ?? this.portfolioImages,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      workHours: workHours ?? this.workHours,
      socialMedia: socialMedia ?? this.socialMedia,
      joinDate: joinDate ?? this.joinDate,
      isVerified: isVerified ?? this.isVerified,
      specialties: specialties ?? this.specialties,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'serviceType': serviceType,
      'city': city,
      'description': description,
      'profileImage': profileImage,
      'portfolioImages': portfolioImages,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'workHours': workHours,
      'socialMedia': socialMedia,
      'joinDate': joinDate.toIso8601String(),
      'isVerified': isVerified,
      'specialties': specialties,
      'isProfileComplete': isProfileComplete,
    };
  }

  factory ServiceProviderProfile.fromJson(Map<String, dynamic> json) {
    return ServiceProviderProfile(
      userId: json['userId'],
      serviceType: json['serviceType'],
      city: json['city'],
      description: json['description'],
      profileImage: json['profileImage'],
      portfolioImages: List<String>.from(json['portfolioImages'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewsCount: json['reviewsCount'] ?? 0,
      workHours: json['workHours'],
      socialMedia: json['socialMedia'] != null
          ? Map<String, String>.from(json['socialMedia'])
          : null,
      joinDate: DateTime.parse(json['joinDate']),
      isVerified: json['isVerified'] ?? false,
      specialties: List<String>.from(json['specialties'] ?? []),
      isProfileComplete: json['isProfileComplete'] ?? false,
    );
  }
}