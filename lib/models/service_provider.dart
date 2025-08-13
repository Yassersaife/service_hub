import 'package:flutter/material.dart';

class ServiceProvider {
  final String name;
  final String service;
  final String city;
  final String phone;
  final String? email;
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

  ServiceProvider({
    required this.name,
    required this.service,
    required this.city,
    required this.phone,
    this.email,
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
  }) : joinDate = joinDate ?? DateTime.now();

  String getServiceLabel() {
    switch (service) {
      case 'photographer':
        return 'مصور';
      case 'video-editor':
        return 'مونتاج فيديوهات';
      case 'photo-editor':
        return 'تعديل صور';
      case 'printer':
        return 'طباعة صور';
      default:
        return service;
    }
  }

  IconData getServiceIcon() {
    switch (service) {
      case 'photographer':
        return Icons.camera_alt;
      case 'video-editor':
        return Icons.video_camera_back;
      case 'photo-editor':
        return Icons.edit;
      case 'printer':
        return Icons.print;
      default:
        return Icons.work;
    }
  }

  String getExperienceText() {
    final now = DateTime.now();
    final difference = now.difference(joinDate);
    final years = (difference.inDays / 365).floor();
    final months = ((difference.inDays % 365) / 30).floor();

    if (years > 0) {
      return years == 1 ? 'سنة واحدة' : '$years سنوات';
    } else if (months > 0) {
      return months == 1 ? 'شهر واحد' : '$months أشهر';
    } else {
      return 'جديد';
    }
  }

  // نسخة محدثة من ServiceProvider
  ServiceProvider copyWith({
    String? name,
    String? service,
    String? city,
    String? phone,
    String? email,
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
  }) {
    return ServiceProvider(
      name: name ?? this.name,
      service: service ?? this.service,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      email: email ?? this.email,
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
    );
  }
}