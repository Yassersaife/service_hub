import 'package:flutter/material.dart';
import 'dart:convert';

class ProviderProfile {
  final int id;
  final int userId;
  final int? categoryId;
  final String? address;
  final String city;
  final String? description;
  final String? profileImage;
  final String? profileImageUrl;
  final List<String>? portfolioImages;
  final List<String>? portfolioImagesUrls;
  final String? workHours;
  final String? whatsappNumber;
  final bool isVerified;
  final bool isFeatured;
  final bool isComplete;
  final Map<String, dynamic>? socialMedia;
  final DateTime createdAt;
  final DateTime updatedAt;

  final Map<String, dynamic>? user;
  final Map<String, dynamic>? category;
  final List<Map<String, dynamic>>? services;

  final int? servicesCount;
  final Map<String, dynamic>? status;
  final Map<String, dynamic>? displayInfo;

  const ProviderProfile({
    required this.id,
    required this.userId,
    this.categoryId,
    this.address,
    required this.city,
    this.description,
    this.profileImage,
    this.profileImageUrl,
    this.portfolioImages,
    this.portfolioImagesUrls,
    this.workHours,
    this.whatsappNumber,
    this.isVerified = false,
    this.isFeatured = false,
    this.isComplete = false,
    this.socialMedia,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.category,
    this.services,
    this.servicesCount,
    this.status,
    this.displayInfo,
  });

  ProviderProfile copyWith({
    int? id,
    int? userId,
    int? categoryId,
    String? address,
    String? city,
    String? description,
    String? profileImage,
    String? profileImageUrl,
    List<String>? portfolioImages,
    List<String>? portfolioImagesUrls,
    String? workHours,
    String? whatsappNumber,
    bool? isVerified,
    bool? isFeatured,
    bool? isComplete,
    Map<String, dynamic>? socialMedia,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? user,
    Map<String, dynamic>? category,
    List<Map<String, dynamic>>? services,
    int? servicesCount,
    Map<String, dynamic>? status,
    Map<String, dynamic>? displayInfo,
  }) {
    return ProviderProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      address: address ?? this.address,
      city: city ?? this.city,
      description: description ?? this.description,
      profileImage: profileImage ?? this.profileImage,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      portfolioImages: portfolioImages ?? this.portfolioImages,
      portfolioImagesUrls: portfolioImagesUrls ?? this.portfolioImagesUrls,
      workHours: workHours ?? this.workHours,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      isVerified: isVerified ?? this.isVerified,
      isFeatured: isFeatured ?? this.isFeatured,
      isComplete: isComplete ?? this.isComplete,
      socialMedia: socialMedia ?? this.socialMedia,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      category: category ?? this.category,
      services: services ?? this.services,
      servicesCount: servicesCount ?? this.servicesCount,
      status: status ?? this.status,
      displayInfo: displayInfo ?? this.displayInfo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'address': address,
      'city': city,
      'description': description,
      'profile_image': profileImage,
      'profile_image_url': profileImageUrl,
      'portfolio_images': portfolioImages,
      'portfolio_images_urls': portfolioImagesUrls,
      'work_hours': workHours,
      'whatsapp_number': whatsappNumber,
      'is_verified': isVerified,
      'is_featured': isFeatured,
      'is_complete': isComplete,
      'social_media': socialMedia is Map ? jsonEncode(socialMedia) : socialMedia,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user,
      'category': category,
      'services': services,
      'services_count': servicesCount,
      'status': status,
      'display_info': displayInfo,
    };
  }

  factory ProviderProfile.fromJson(Map<String, dynamic> json) {
    try {
      // معالجة portfolio_images - تحسين التعامل مع المصفوفات الفارغة
      List<String>? portfolioImages;
      if (json['portfolio_images'] != null) {
        if (json['portfolio_images'] is List) {
          final list = json['portfolio_images'] as List;
          portfolioImages = list.isNotEmpty ? List<String>.from(list) : [];
        } else if (json['portfolio_images'] is String && json['portfolio_images'].isNotEmpty) {
          try {
            final decoded = jsonDecode(json['portfolio_images']);
            if (decoded is List) {
              portfolioImages = List<String>.from(decoded);
            }
          } catch (e) {
            print('Error decoding portfolio_images: $e');
            portfolioImages = [];
          }
        } else {
          portfolioImages = [];
        }
      }

      // معالجة portfolio_images_urls - تحسين التعامل مع المصفوفات الفارغة
      List<String>? portfolioImagesUrls;
      if (json['portfolio_images_urls'] != null) {
        if (json['portfolio_images_urls'] is List) {
          final list = json['portfolio_images_urls'] as List;
          portfolioImagesUrls = list.isNotEmpty ? List<String>.from(list) : [];
        } else {
          portfolioImagesUrls = [];
        }
      }

      // معالجة social_media - تحسين التعامل مع النصوص والكائنات
      Map<String, dynamic>? socialMedia;
      if (json['social_media'] != null) {
        if (json['social_media'] is Map) {
          socialMedia = Map<String, dynamic>.from(json['social_media']);
        } else if (json['social_media'] is String && json['social_media'].isNotEmpty) {
          try {
            final decoded = jsonDecode(json['social_media']);
            if (decoded is Map) {
              socialMedia = Map<String, dynamic>.from(decoded);
            }
          } catch (e) {
            print('Error decoding social_media: $e');
            // في حالة فشل التحويل، نحاول التعامل مع النص كما هو
            socialMedia = {'raw': json['social_media']};
          }
        }
      }

      // معالجة services - تحسين التعامل مع المصفوفات الفارغة
      List<Map<String, dynamic>>? services;
      if (json['services'] != null && json['services'] is List) {
        final list = json['services'] as List;
        services = list.isNotEmpty
            ? List<Map<String, dynamic>>.from(
          list.map((service) => Map<String, dynamic>.from(service ?? {})),
        )
            : [];
      }

      // معالجة status - تحسين التعامل مع الكائنات
      Map<String, dynamic>? status;
      if (json['status'] != null && json['status'] is Map) {
        status = Map<String, dynamic>.from(json['status']);
      }

      // معالجة display_info - تحسين التعامل مع الكائنات
      Map<String, dynamic>? displayInfo;
      if (json['display_info'] != null && json['display_info'] is Map) {
        displayInfo = Map<String, dynamic>.from(json['display_info']);
      }

      // معالجة التواريخ مع التعامل مع التنسيقات المختلفة
      DateTime createdAt;
      DateTime updatedAt;

      try {
        createdAt = DateTime.parse(json['created_at']);
      } catch (e) {
        print('Error parsing created_at: $e');
        createdAt = DateTime.now();
      }

      try {
        updatedAt = DateTime.parse(json['updated_at']);
      } catch (e) {
        print('Error parsing updated_at: $e');
        updatedAt = DateTime.now();
      }

      // معالجة user object
      Map<String, dynamic>? user;
      if (json['user'] != null && json['user'] is Map) {
        user = Map<String, dynamic>.from(json['user']);
      }

      // معالجة category object
      Map<String, dynamic>? category;
      if (json['category'] != null && json['category'] is Map) {
        category = Map<String, dynamic>.from(json['category']);
      }

      return ProviderProfile(
        id: _parseToInt(json['id']),
        userId: _parseToInt(json['user_id']),
        categoryId: json['category_id'] != null ? _parseToInt(json['category_id']) : null,
        address: json['address']?.toString(),
        city: json['city']?.toString() ?? '',
        description: json['description']?.toString(),
        profileImage: json['profile_image']?.toString(),
        profileImageUrl: json['profile_image_url']?.toString(),
        portfolioImages: portfolioImages,
        portfolioImagesUrls: portfolioImagesUrls,
        workHours: json['work_hours']?.toString(),
        whatsappNumber: json['whatsapp_number']?.toString(),
        isVerified: _parseToBool(json['is_verified']),
        isFeatured: _parseToBool(json['is_featured']),
        isComplete: _parseToBool(json['is_complete']),
        socialMedia: socialMedia,
        createdAt: createdAt,
        updatedAt: updatedAt,
        user: user,
        category: category,
        services: services,
        servicesCount: json['services_count'] != null ? _parseToInt(json['services_count']) : null,
        status: status,
        displayInfo: displayInfo,
      );
    } catch (e, stackTrace) {
      print('Error in ProviderProfile.fromJson: $e');
      print('Stack trace: $stackTrace');
      print('JSON data was: $json');
      rethrow;
    }
  }

  // Helper methods للتحويل الآمن للأنواع
  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is double) return value.toInt();
    return 0;
  }

  static bool _parseToBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int) return value == 1;
    return false;
  }

  // Helper getters
  String? get userName => user?['name']?.toString() ?? displayInfo?['full_name']?.toString();
  String? get userEmail => user?['email']?.toString();
  String? get userPhone => user?['phone']?.toString() ?? displayInfo?['contact_phone']?.toString();
  String get displayName => userName ?? 'مقدم خدمة';

  String? get categoryName => category?['name']?.toString();

  int get count => this.servicesCount ?? services?.length ?? 0;
  bool get hasServices => count > 0;
  bool get hasPortfolio => (portfolioImages?.isNotEmpty ?? false) ||
      (portfolioImagesUrls?.isNotEmpty ?? false) ||
      (displayInfo?['has_portfolio'] == true);

  List<String> get allPortfolioImages {
    List<String> allImages = [];
    if (portfolioImagesUrls != null && portfolioImagesUrls!.isNotEmpty) {
      allImages.addAll(portfolioImagesUrls!);
    }
    if (portfolioImages != null && portfolioImages!.isNotEmpty) {
      allImages.addAll(portfolioImages!);
    }
    return allImages;
  }

  // تحسين Social Media getters
  Map<String, dynamic> get socialMediaData => socialMedia ?? {};
  String? get instagramHandle => socialMediaData['instagram']?.toString();
  String? get facebookHandle => socialMediaData['facebook']?.toString();
  String? get websiteUrl => socialMediaData['website']?.toString();
  String? get twitterHandle => socialMediaData['twitter']?.toString();
  String? get linkedinHandle => socialMediaData['linkedin']?.toString();

  // Status helpers - يستخدم status object أو القيم الأصلية
  String get statusText {
    final isCompleteStatus = status?['complete'] ?? isComplete;
    final isVerifiedStatus = status?['verified'] ?? isVerified;
    final isFeaturedStatus = status?['featured'] ?? isFeatured;

    if (!isCompleteStatus) return 'البروفايل غير مكتمل';
    if (isVerifiedStatus && isFeaturedStatus) return 'موثق ومميز';
    if (isVerifiedStatus) return 'موثق';
    if (isFeaturedStatus) return 'مميز';
    return 'نشط';
  }

  Color get statusColor {
    final isCompleteStatus = status?['complete'] ?? isComplete;
    final isVerifiedStatus = status?['verified'] ?? isVerified;
    final isFeaturedStatus = status?['featured'] ?? isFeatured;

    if (!isCompleteStatus) return Colors.grey;
    if (isVerifiedStatus && isFeaturedStatus) return Colors.purple;
    if (isVerifiedStatus) return Colors.green;
    if (isFeaturedStatus) return Colors.blue;
    return Colors.orange;
  }

  IconData get statusIcon {
    final isCompleteStatus = status?['complete'] ?? isComplete;
    final isVerifiedStatus = status?['verified'] ?? isVerified;
    final isFeaturedStatus = status?['featured'] ?? isFeatured;

    if (!isCompleteStatus) return Icons.info;
    if (isVerifiedStatus && isFeaturedStatus) return Icons.star;
    if (isVerifiedStatus) return Icons.verified;
    if (isFeaturedStatus) return Icons.featured_play_list;
    return Icons.person;
  }

  // Display Info helpers
  String get location => displayInfo?['location']?.toString() ?? city;
  String? get whatsappContact => displayInfo?['whatsapp']?.toString() ?? whatsappNumber;
  int get portfolioCount => (displayInfo?['portfolio_count'] as int?) ?? allPortfolioImages.length;

  // Service-based helpers (fallback to category)
  IconData getServiceIcon() {
    final catName = categoryName?.toLowerCase() ?? '';

    if (catName.contains('تصوير') || catName.contains('photo')) {
      return Icons.camera_alt;
    } else if (catName.contains('تصميم') || catName.contains('design') || catName.contains('جرافيك')) {
      return Icons.brush;
    } else if (catName.contains('طباعة') || catName.contains('print')) {
      return Icons.print;
    } else if (catName.contains('رقمية') || catName.contains('digital')) {
      return Icons.computer;
    } else if (catName.contains('برمجة') || catName.contains('تطوير')) {
      return Icons.code;
    } else if (catName.contains('موقع') || catName.contains('ويب')) {
      return Icons.web;
    }

    return Icons.work;
  }

  Color getServiceColor() {
    final catName = categoryName?.toLowerCase() ?? '';

    if (catName.contains('تصوير') || catName.contains('photo')) {
      return const Color(0xFF3B82F6);
    } else if (catName.contains('تصميم') || catName.contains('design') || catName.contains('جرافيك')) {
      return const Color(0xFF10B981);
    } else if (catName.contains('طباعة') || catName.contains('print')) {
      return const Color(0xFF8B5CF6);
    } else if (catName.contains('رقمية') || catName.contains('digital')) {
      return const Color(0xFFEF4444);
    } else if (catName.contains('برمجة') || catName.contains('تطوير')) {
      return const Color(0xFF1D4ED8);
    } else if (catName.contains('موقع') || catName.contains('ويب')) {
      return const Color(0xFF059669);
    }

    return const Color(0xFF6B7280);
  }

  String getExperienceText() {
    final experienceYears = DateTime.now().difference(createdAt).inDays ~/ 365;

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

  // إضافة validator للبيانات المطلوبة
  bool get isValidProfile {
    return id > 0 &&
        userId > 0 &&
        city.isNotEmpty &&
        userName?.isNotEmpty == true;
  }

  // Method خاصة لإرسال البيانات للـ API
  Map<String, dynamic> toApiJson() {
    return {
      'user_id': userId,
      'category_id': categoryId,
      'address': address,
      'city': city,
      'description': description,
      'work_hours': workHours,
      'whatsapp_number': whatsappNumber,
      'is_verified': isVerified,
      'is_featured': isFeatured,
      'is_complete': isComplete,
      'social_media': socialMedia ?? {}, // كـ Map/Object
    };
  }

  // Method لتحويل social media إلى format مناسب للـ API
  Map<String, String> get socialMediaForApi {
    if (socialMedia == null) return {};

    Map<String, String> result = {};
    socialMedia!.forEach((key, value) {
      if (value != null) {
        result[key] = value.toString();
      }
    });
    return result;
  }

  // إضافة method لتحديد اكتمال البروفايل
  double get completionPercentage {
    int totalFields = 10;
    int completedFields = 0;

    if (userName?.isNotEmpty == true) completedFields++;
    if (userEmail?.isNotEmpty == true) completedFields++;
    if (userPhone?.isNotEmpty == true) completedFields++;
    if (address?.isNotEmpty == true) completedFields++;
    if (description?.isNotEmpty == true) completedFields++;
    if (profileImage?.isNotEmpty == true) completedFields++;
    if (workHours?.isNotEmpty == true) completedFields++;
    if (whatsappNumber?.isNotEmpty == true) completedFields++;
    if (categoryId != null) completedFields++;
    if (socialMediaData.isNotEmpty) completedFields++;

    return (completedFields / totalFields) * 100;
  }

  @override
  String toString() {
    return 'ProviderProfile(id: $id, userId: $userId, name: $userName, city: $city, isVerified: $isVerified, isFeatured: $isFeatured, isComplete: $isComplete)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProviderProfile &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}