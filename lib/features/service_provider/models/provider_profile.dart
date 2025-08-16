// lib/features/service_provider/models/provider_profile.dart
import 'package:flutter/material.dart';

class ProviderProfile {
  final String userId;
  final String? name; // إضافة الاسم
  final String? address; // إضافة العنوان
  final String? phoneNumber; // إضافة رقم الهاتف
  final String? whatsappNumber; // إضافة رقم الواتساب
  final String serviceType;
  final String city;
  final String? description;
  final String? profileImage;
  final List<String> portfolioImages;
  final double rating;
  final int reviewsCount;
  final String? workHours;
  final bool isVerified;
  final List<String> specialties;
  final Map<String, String> socialMedia;
  final DateTime joinDate;
  final bool isComplete;

  const ProviderProfile({
    required this.userId,
    this.name,
    this.address,
    this.phoneNumber,
    this.whatsappNumber,
    required this.serviceType,
    required this.city,
    this.description,
    this.profileImage,
    this.portfolioImages = const [],
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.workHours,
    this.isVerified = false,
    this.specialties = const [],
    this.socialMedia = const {},
    required this.joinDate,
    this.isComplete = false,
  });

  // نسخ مع تعديل
  ProviderProfile copyWith({
    String? userId,
    String? name,
    String? address,
    String? phoneNumber,
    String? whatsappNumber,
    String? serviceType,
    String? city,
    String? description,
    String? profileImage,
    List<String>? portfolioImages,
    double? rating,
    int? reviewsCount,
    String? workHours,
    bool? isVerified,
    List<String>? specialties,
    Map<String, String>? socialMedia,
    DateTime? joinDate,
    bool? isComplete,
  }) {
    return ProviderProfile(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      serviceType: serviceType ?? this.serviceType,
      city: city ?? this.city,
      description: description ?? this.description,
      profileImage: profileImage ?? this.profileImage,
      portfolioImages: portfolioImages ?? this.portfolioImages,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      workHours: workHours ?? this.workHours,
      isVerified: isVerified ?? this.isVerified,
      specialties: specialties ?? this.specialties,
      socialMedia: socialMedia ?? this.socialMedia,
      joinDate: joinDate ?? this.joinDate,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  // تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'address': address,
      'phoneNumber': phoneNumber,
      'whatsappNumber': whatsappNumber,
      'serviceType': serviceType,
      'city': city,
      'description': description,
      'profileImage': profileImage,
      'portfolioImages': portfolioImages,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'workHours': workHours,
      'isVerified': isVerified,
      'specialties': specialties,
      'socialMedia': socialMedia,
      'joinDate': joinDate.toIso8601String(),
      'isComplete': isComplete,
    };
  }

  // إنشاء من JSON
  factory ProviderProfile.fromJson(Map<String, dynamic> json) {
    return ProviderProfile(
      userId: json['userId'] as String,
      name: json['name'] as String?,
      address: json['address'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      whatsappNumber: json['whatsappNumber'] as String?,
      serviceType: json['serviceType'] as String,
      city: json['city'] as String,
      description: json['description'] as String?,
      profileImage: json['profileImage'] as String?,
      portfolioImages: List<String>.from(json['portfolioImages'] ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviewsCount'] as int? ?? 0,
      workHours: json['workHours'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      specialties: List<String>.from(json['specialties'] ?? []),
      socialMedia: Map<String, String>.from(json['socialMedia'] ?? {}),
      joinDate: DateTime.parse(json['joinDate'] as String),
      isComplete: json['isComplete'] as bool? ?? false,
    );
  }

  // الحصول على تسمية الخدمة
  String getServiceLabel() {
    switch (serviceType) {
      case 'photographer':
        return 'مصور فوتوغرافي';
      case 'video-editor':
        return 'محرر فيديو';
      case 'photo-editor':
        return 'محرر صور';
      case 'printer':
        return 'مطبعة';
      case 'graphic-designer':
        return 'مصمم جرافيك';
      case 'videographer':
        return 'مصور فيديو';
      case 'drone-photographer':
        return 'مصور طائرات مسيرة';
      case 'event-photographer':
        return 'مصور مناسبات';
      case 'studio-photographer':
        return 'مصور استوديو';
      case 'product-photographer':
        return 'مصور منتجات';
      default:
        return 'مقدم خدمة';
    }
  }

  // الحصول على أيقونة الخدمة
  IconData getServiceIcon() {
    switch (serviceType) {
      case 'photographer':
      case 'event-photographer':
      case 'studio-photographer':
      case 'product-photographer':
        return Icons.camera_alt;
      case 'video-editor':
      case 'videographer':
        return Icons.video_camera_back;
      case 'photo-editor':
      case 'graphic-designer':
        return Icons.edit;
      case 'printer':
        return Icons.print;
      case 'drone-photographer':
        return Icons.flight;
      default:
        return Icons.work;
    }
  }

  // الحصول على لون الخدمة
  Color getServiceColor() {
    switch (serviceType) {
      case 'photographer':
      case 'event-photographer':
      case 'studio-photographer':
      case 'product-photographer':
        return const Color(0xFF3B82F6); // أزرق
      case 'video-editor':
      case 'videographer':
        return const Color(0xFFEF4444); // أحمر
      case 'photo-editor':
      case 'graphic-designer':
        return const Color(0xFF10B981); // أخضر
      case 'printer':
        return const Color(0xFF8B5CF6); // بنفسجي
      case 'drone-photographer':
        return const Color(0xFFF59E0B); // برتقالي
      default:
        return const Color(0xFF6B7280); // رمادي
    }
  }

  // الحصول على نص الخبرة
  String getExperienceText() {
    final now = DateTime.now();
    final experienceYears = now.difference(joinDate).inDays ~/ 365;

    if (experienceYears == 0) {
      return 'أقل من سنة';
    } else if (experienceYears == 1) {
      return 'سنة واحدة';
    } else if (experienceYears == 2) {
      return 'سنتان';
    } else if (experienceYears <= 10) {
      return '$experienceYears سنوات';
    } else {
      return 'أكثر من 10 سنوات';
    }
  }

  // التحقق من اكتمال الملف الشخصي
  bool get isProfileComplete {
    return name != null &&
        name!.isNotEmpty &&
        description != null &&
        description!.isNotEmpty &&
        city.isNotEmpty &&
        serviceType.isNotEmpty;
  }

  // الحصول على تقييم نصي
  String getRatingText() {
    if (rating >= 4.5) {
      return 'ممتاز';
    } else if (rating >= 4.0) {
      return 'جيد جداً';
    } else if (rating >= 3.5) {
      return 'جيد';
    } else if (rating >= 3.0) {
      return 'مقبول';
    } else {
      return 'ضعيف';
    }
  }

  // الحصول على عدد سنوات الخبرة كرقم
  int getExperienceYears() {
    final now = DateTime.now();
    return now.difference(joinDate).inDays ~/ 365;
  }

  @override
  String toString() {
    return 'ProviderProfile(userId: $userId, name: $name, serviceType: $serviceType, city: $city, rating: $rating)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProviderProfile &&
              runtimeType == other.runtimeType &&
              userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}