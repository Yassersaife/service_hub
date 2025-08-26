import 'package:flutter/material.dart';
import 'dart:convert';

class ProviderProfile {
  final String userId;
  final String? name;
  final String? address;
  final String? phoneNumber;
  final String? whatsappNumber;
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
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    this.createdAt,
    this.updatedAt,
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
    DateTime? createdAt,
    DateTime? updatedAt,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // تحويل إلى JSON للإرسال إلى API
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'address': address,
      'phone_number': phoneNumber,
      'whatsapp_number': whatsappNumber,
      'service_type': serviceType,
      'city': city,
      'description': description,
      'profile_image': profileImage,
      'portfolio_images': portfolioImages,
      'rating': rating,
      'reviews_count': reviewsCount,
      'work_hours': workHours,
      'is_verified': isVerified,
      'specialties': specialties,
      'social_media': socialMedia,
      'join_date': joinDate.toIso8601String(),
      'is_complete': isComplete,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // إنشاء من JSON من API
  factory ProviderProfile.fromJson(Map<String, dynamic> json) {
    return ProviderProfile(
      userId: json['user_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] as String?,
      address: json['address'] as String?,
      phoneNumber: json['phone_number'] as String?,
      whatsappNumber: json['whatsapp_number'] as String?,
      serviceType: json['service_type'] as String? ?? '',
      city: json['city'] as String? ?? '',
      description: json['description'] as String?,
      profileImage: json['profile_image'] as String?,
      portfolioImages: _parseStringList(json['portfolio_images']),
      rating: _parseDouble(json['rating']) ?? 0.0,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      workHours: json['work_hours'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      specialties: _parseStringList(json['specialties']),
      socialMedia: _parseSocialMedia(json['social_media']),
      joinDate: _parseDateTime(json['join_date']) ??
          _parseDateTime(json['created_at']) ??
          DateTime.now(),
      isComplete: json['is_complete'] as bool? ?? false,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  // Helper methods لتحويل البيانات
  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    if (value is String) {
      try {
        // إذا كانت JSON string
        return List<String>.from(json.decode(value));
      } catch (e) {
        return [value];
      }
    }
    return [];
  }

  static Map<String, String> _parseSocialMedia(dynamic value) {
    if (value == null) return {};
    if (value is Map) {
      return Map<String, String>.from(value);
    }
    if (value is String) {
      try {
        return Map<String, String>.from(json.decode(value));
      } catch (e) {
        return {};
      }
    }
    return {};
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // الحصول على تسمية الخدمة
  String getServiceLabel() {
    switch (serviceType.toLowerCase()) {
      case 'photographer':
      case 'photography':
        return 'مصور فوتوغرافي';
      case 'video-editor':
      case 'video_editor':
      case 'videographer':
        return 'محرر فيديو';
      case 'photo-editor':
      case 'photo_editor':
        return 'محرر صور';
      case 'printer':
      case 'printing':
        return 'مطبعة';
      case 'graphic-designer':
      case 'graphic_designer':
        return 'مصمم جرافيك';
      case 'drone-photographer':
      case 'drone_photographer':
        return 'مصور طائرات مسيرة';
      case 'event-photographer':
      case 'event_photographer':
        return 'مصور مناسبات';
      case 'studio-photographer':
      case 'studio_photographer':
        return 'مصور استوديو';
      case 'product-photographer':
      case 'product_photographer':
        return 'مصور منتجات';
      default:
        return serviceType.isNotEmpty ? serviceType : 'مقدم خدمة';
    }
  }

  // الحصول على أيقونة الخدمة
  IconData getServiceIcon() {
    switch (serviceType.toLowerCase()) {
      case 'photographer':
      case 'photography':
      case 'event-photographer':
      case 'event_photographer':
      case 'studio-photographer':
      case 'studio_photographer':
      case 'product-photographer':
      case 'product_photographer':
        return Icons.camera_alt;
      case 'video-editor':
      case 'video_editor':
      case 'videographer':
        return Icons.video_camera_back;
      case 'photo-editor':
      case 'photo_editor':
      case 'graphic-designer':
      case 'graphic_designer':
        return Icons.edit;
      case 'printer':
      case 'printing':
        return Icons.print;
      case 'drone-photographer':
      case 'drone_photographer':
        return Icons.flight;
      default:
        return Icons.work;
    }
  }

  // الحصول على لون الخدمة
  Color getServiceColor() {
    switch (serviceType.toLowerCase()) {
      case 'photographer':
      case 'photography':
      case 'event-photographer':
      case 'event_photographer':
      case 'studio-photographer':
      case 'studio_photographer':
      case 'product-photographer':
      case 'product_photographer':
        return const Color(0xFF3B82F6); // أزرق
      case 'video-editor':
      case 'video_editor':
      case 'videographer':
        return const Color(0xFFEF4444); // أحمر
      case 'photo-editor':
      case 'photo_editor':
      case 'graphic-designer':
      case 'graphic_designer':
        return const Color(0xFF10B981); // أخضر
      case 'printer':
      case 'printing':
        return const Color(0xFF8B5CF6); // بنفسجي
      case 'drone-photographer':
      case 'drone_photographer':
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