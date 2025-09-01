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
  final bool isfeatured ;

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
    this.isfeatured = false,
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
    bool? isfeatured,
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
      isfeatured: isfeatured ?? this.isfeatured,
    );
  }

  // تحويل إلى JSON بسيط
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name ?? '',
      'address': address ?? '',
      'phone_number': phoneNumber ?? '',
      'whatsapp_number': whatsappNumber ?? '',
      'service_type': serviceType,
      'city': city,
      'description': description ?? '',
      'work_hours': workHours ?? '',
      'selected_services': specialties, // استخدام specialties كـ selected_services
      'services_prices': {}, // مطلوب في الـ API
      'rating': rating,
      'reviews_count': reviewsCount,
      'is_verified': isVerified,
      'social_media': socialMedia.isNotEmpty ? socialMedia : {},
      'join_date': joinDate.toIso8601String(),
      'is_complete': isComplete,
      'is_featured': isfeatured,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  // إنشاء من JSON محسن
  factory ProviderProfile.fromJson(dynamic json) {
    try {
      print('Raw JSON data: $json');

      // إذا كان json هو List، خذ أول عنصر
      if (json is List && json.isNotEmpty) {
        json = json.first;
      }

      // إذا لم يكن Map، ارجع profile فارغ
      if (json is! Map<String, dynamic>) {
        print('Invalid JSON format: ${json.runtimeType}');
        return ProviderProfile(
          userId: '',
          serviceType: '',
          city: '',
          joinDate: DateTime.now(),
        );
      }

      final Map<String, dynamic> data = json;

      // معالجة portfolio_images
      List<String> portfolioImages = [];
      if (data['portfolio_images'] != null) {
        try {
          if (data['portfolio_images'] is List) {
            portfolioImages = (data['portfolio_images'] as List)
                .map((e) => e.toString())
                .where((url) => url.isNotEmpty)
                .toList();
          } else if (data['portfolio_images'] is String) {
            // إذا كان JSON string
            try {
              final decoded = jsonDecode(data['portfolio_images']);
              if (decoded is List) {
                portfolioImages = decoded.map((e) => e.toString()).toList();
              }
            } catch (e) {
              print('Error decoding portfolio_images string: $e');
            }
          }
        } catch (e) {
          print('Error processing portfolio_images: $e');
        }
      }

      // معالجة social_media بشكل آمن
      Map<String, String> socialMediaMap = {};
      if (data['social_media'] != null) {
        try {
          if (data['social_media'] is Map) {
            final socialData = data['social_media'] as Map;
            socialMediaMap = socialData.map((key, value) =>
                MapEntry(key.toString(), value?.toString() ?? ''));
          } else if (data['social_media'] is String) {
            // إذا كان JSON string
            try {
              final decoded = jsonDecode(data['social_media']);
              if (decoded is Map) {
                socialMediaMap = (decoded as Map).map((key, value) =>
                    MapEntry(key.toString(), value?.toString() ?? ''));
              }
            } catch (e) {
              print('Error decoding social_media string: $e');
            }
          }
        } catch (e) {
          print('Error processing social_media: $e');
        }
      }

      // معالجة specialties/selected_services
      List<String> specialties = [];

      // جرب selected_services أولاً
      if (data['selected_services'] != null) {
        try {
          if (data['selected_services'] is List) {
            specialties = (data['selected_services'] as List)
                .map((e) => e.toString())
                .where((item) => item.isNotEmpty)
                .toList();
          } else if (data['selected_services'] is String) {
            // إذا كان JSON string
            try {
              final decoded = jsonDecode(data['selected_services']);
              if (decoded is List) {
                specialties = decoded.map((e) => e.toString()).toList();
              }
            } catch (e) {
              print('Error decoding selected_services string: $e');
            }
          }
        } catch (e) {
          print('Error processing selected_services: $e');
        }
      }

      // إذا فشل، جرب specialties
      if (specialties.isEmpty && data['specialties'] != null) {
        try {
          if (data['specialties'] is List) {
            specialties = (data['specialties'] as List)
                .map((e) => e.toString())
                .where((item) => item.isNotEmpty)
                .toList();
          } else if (data['specialties'] is String) {
            try {
              final decoded = jsonDecode(data['specialties']);
              if (decoded is List) {
                specialties = decoded.map((e) => e.toString()).toList();
              }
            } catch (e) {
              print('Error decoding specialties string: $e');
            }
          }
        } catch (e) {
          print('Error processing specialties: $e');
        }
      }

      print('Processed data:');
      print('- Portfolio images: $portfolioImages');
      print('- Social media: $socialMediaMap');
      print('- Specialties: $specialties');

      // معالجة user data إذا كان موجود
      String? userName;
      String? userPhone;

      if (data['user'] != null && data['user'] is Map) {
        final userData = data['user'] as Map<String, dynamic>;
        userName = userData['name']?.toString();
        userPhone = userData['phone']?.toString();
      }

      return ProviderProfile(
        userId: data['user_id']?.toString() ?? data['id']?.toString() ?? '',
        name: data['name']?.toString() ?? userName,
        address: data['address']?.toString(),
        phoneNumber: data['phone_number']?.toString() ??
            data['phone']?.toString() ??
            userPhone,
        whatsappNumber: data['whatsapp_number']?.toString(),
        serviceType: data['service_type']?.toString() ?? '',
        city: data['city']?.toString() ?? '',
        description: data['description']?.toString(),
        profileImage: data['profile_image']?.toString(),
        portfolioImages: portfolioImages,
        rating: double.tryParse(data['rating']?.toString() ?? '0') ?? 0.0,
        reviewsCount: int.tryParse(data['reviews_count']?.toString() ?? '0') ?? 0,
        workHours: data['work_hours']?.toString(),
        isVerified: data['is_verified'] == true || data['is_verified'] == 1 || data['is_verified'] == '1',
        isfeatured: data['is_featured'] == true || data['is_featured'] == 1 || data['is_featured'] == '1',
        specialties: specialties,
        socialMedia: socialMediaMap,
        joinDate: DateTime.tryParse(data['join_date']?.toString() ?? '') ??
            DateTime.tryParse(data['created_at']?.toString() ?? '') ??
            DateTime.now(),
        isComplete: data['is_complete'] == true || data['is_complete'] == 1 || data['is_complete'] == '1',
        createdAt: DateTime.tryParse(data['created_at']?.toString() ?? ''),
        updatedAt: DateTime.tryParse(data['updated_at']?.toString() ?? ''),
      );
    } catch (e) {
      print('Error in ProviderProfile.fromJson: $e');
      print('JSON data was: $json');

      return ProviderProfile(
        userId: '',
        serviceType: '',
        city: '',
        joinDate: DateTime.now(),
      );
    }
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
    return 'ProviderProfile(userId: $userId, name: $name, serviceType: $serviceType,isfeatured: $isfeatured,isverified: $isVerified, city: $city, portfolioImages: ${portfolioImages.length}, socialMedia: $socialMedia)';
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