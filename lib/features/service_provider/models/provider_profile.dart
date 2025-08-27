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

  // تحويل إلى JSON بسيط
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name ?? '',
      'address': address ?? 'غير محدد',
      'phone_number': phoneNumber ?? '',
      'whatsapp_number': whatsappNumber ?? '',
      'service_type': serviceType,
      'city': city,
      'description': description ?? 'لا يوجد وصف',
      'work_hours': workHours ?? 'غير محدد',
      'selected_services': [], // مطلوب في الـ API
      'services_prices': {}, // مطلوب في الـ API
      'rating': rating,
      'reviews_count': reviewsCount,
      'is_verified': isVerified,
      'social_media': socialMedia.isNotEmpty ? socialMedia : {},
      'join_date': joinDate.toIso8601String(),
      'is_complete': isComplete,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // إنشاء من JSON بسيط
  factory ProviderProfile.fromJson(dynamic json) {
    // إذا كان json هو List، خذ أول عنصر
    if (json is List && json.isNotEmpty) {
      json = json.first;
    }

    // إذا لم يكن Map، ارجع profile فارغ
    if (json is! Map<String, dynamic>) {
      return ProviderProfile(
        userId: '',
        serviceType: '',
        city: '',
        joinDate: DateTime.now(),
      );
    }

    // معالجة social_media بشكل آمن
    Map<String, String> socialMediaMap = {};
    if (json['social_media'] != null) {
      if (json['social_media'] is Map) {
        socialMediaMap = Map<String, String>.from(json['social_media']);
      } else if (json['social_media'] is List) {
        // إذا كان List فارغ، اتركه فارغ
        socialMediaMap = {};
      }
    }

    return ProviderProfile(
      userId: json['user_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString(),
      address: json['address']?.toString(),
      phoneNumber: json['phone_number']?.toString() ?? json['phone']?.toString(),
      whatsappNumber: json['whatsapp_number']?.toString(),
      serviceType: json['service_type']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      description: json['description']?.toString(),
      profileImage: json['profile_image']?.toString(),
      portfolioImages: (json['portfolio_images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      reviewsCount: int.tryParse(json['reviews_count']?.toString() ?? '0') ?? 0,
      workHours: json['work_hours']?.toString(),
      isVerified: json['is_verified'] == true || json['is_verified'] == 1,
      specialties: (json['specialties'] as List?)?.map((e) => e.toString()).toList() ?? [],
      socialMedia: socialMediaMap,
      joinDate: DateTime.tryParse(json['join_date']?.toString() ?? '') ??
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      isComplete: json['is_complete'] == true || json['is_complete'] == 1,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }

  String getServiceLabel() {
    switch (serviceType.toLowerCase()) {
      case 'photography-production':
        return 'إنتاج تصوير';
      case 'design-graphics':
        return 'تصميم جرافيك';
      case 'printing-office':
        return 'مكتب طباعة';
      case 'digital-services':
        return 'خدمات رقمية';
      default:
        return serviceType.isNotEmpty ? serviceType : 'مقدم خدمة';
    }
  }

  IconData getServiceIcon() {
    switch (serviceType.toLowerCase()) {
      case 'photography-production':
        return Icons.camera_alt;
      case 'design-graphics':
        return Icons.brush;
      case 'printing-office':
        return Icons.print;
      case 'digital-services':
        return Icons.computer;
      default:
        return Icons.category;
    }
  }

  Color getServiceColor() {
    switch (serviceType.toLowerCase()) {
      case 'photography-production':
        return const Color(0xFF3B82F6);
      case 'design-graphics':
        return const Color(0xFF10B981);
      case 'printing-office':
        return const Color(0xFF8B5CF6);
      case 'digital-services':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }


  String getExperienceText() {
    final now = DateTime.now();
    final experienceYears = now.difference(joinDate).inDays ~/ 365;

    if (experienceYears == 0) {
      return 'أقل من سنة';
    } else if (experienceYears == 1) {
      return 'سنة واحدة';
    } else if (experienceYears <= 10) {
      return '$experienceYears سنوات';
    } else {
      return 'أكثر من 10 سنوات';
    }
  }

  bool get isProfileComplete {
    return name != null &&
        name!.isNotEmpty &&
        description != null &&
        description!.isNotEmpty &&
        city.isNotEmpty &&
        serviceType.isNotEmpty;
  }

  @override
  String toString() {
    return 'ProviderProfile(userId: $userId, name: $name, serviceType: $serviceType, city: $city)';
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