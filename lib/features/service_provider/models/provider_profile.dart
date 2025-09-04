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

  // User information (when loaded with relationship)
  final Map<String, dynamic>? user;
  final Map<String, dynamic>? category;
  final List<Map<String, dynamic>>? services;

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
      'social_media': socialMedia,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user,
      'category': category,
      'services': services,
    };
  }

  factory ProviderProfile.fromJson(Map<String, dynamic> json) {
    try {
      // معالجة portfolio_images
      List<String>? portfolioImages;
      if (json['portfolio_images'] != null) {
        if (json['portfolio_images'] is List) {
          portfolioImages = List<String>.from(json['portfolio_images']);
        } else if (json['portfolio_images'] is String) {
          try {
            final decoded = jsonDecode(json['portfolio_images']);
            if (decoded is List) {
              portfolioImages = List<String>.from(decoded);
            }
          } catch (e) {
            print('Error decoding portfolio_images: $e');
          }
        }
      }

      // معالجة portfolio_images_urls
      List<String>? portfolioImagesUrls;
      if (json['portfolio_images_urls'] != null && json['portfolio_images_urls'] is List) {
        portfolioImagesUrls = List<String>.from(json['portfolio_images_urls']);
      }

      // معالجة social_media
      Map<String, dynamic>? socialMedia;
      if (json['social_media'] != null) {
        if (json['social_media'] is Map) {
          socialMedia = Map<String, dynamic>.from(json['social_media']);
        } else if (json['social_media'] is String) {
          try {
            final decoded = jsonDecode(json['social_media']);
            if (decoded is Map) {
              socialMedia = Map<String, dynamic>.from(decoded);
            }
          } catch (e) {
            print('Error decoding social_media: $e');
          }
        }
      }

      // معالجة services
      List<Map<String, dynamic>>? services;
      if (json['services'] != null && json['services'] is List) {
        services = List<Map<String, dynamic>>.from(json['services']);
      }

      return ProviderProfile(
        id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
        userId: json['user_id'] is int ? json['user_id'] : int.parse(json['user_id'].toString()),
        categoryId: json['category_id'],
        address: json['address'],
        city: json['city'] ?? '',
        description: json['description'],
        profileImage: json['profile_image'],
        profileImageUrl: json['profile_image_url'],
        portfolioImages: portfolioImages,
        portfolioImagesUrls: portfolioImagesUrls,
        workHours: json['work_hours'],
        whatsappNumber: json['whatsapp_number'],
        isVerified: json['is_verified'] == true,
        isFeatured: json['is_featured'] == true,
        isComplete: json['is_complete'] == true,
        socialMedia: socialMedia,
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        user: json['user'] != null ? Map<String, dynamic>.from(json['user']) : null,
        category: json['category'] != null ? Map<String, dynamic>.from(json['category']) : null,
        services: services,
      );
    } catch (e) {
      print('Error in ProviderProfile.fromJson: $e');
      print('JSON data was: $json');
      rethrow;
    }
  }

  // Helper getters
  String? get userName => user?['name'];
  String? get userEmail => user?['email'];
  String? get userPhone => user?['phone'];
  String get displayName => userName ?? 'مقدم خدمة';

  String? get categoryName => category?['name'];

  int get servicesCount => services?.length ?? 0;
  bool get hasServices => servicesCount > 0;
  bool get hasPortfolio => (portfolioImages?.isNotEmpty ?? false) || (portfolioImagesUrls?.isNotEmpty ?? false);

  List<String> get allPortfolioImages {
    List<String> allImages = [];
    if (portfolioImagesUrls != null) allImages.addAll(portfolioImagesUrls!);
    if (portfolioImages != null) allImages.addAll(portfolioImages!);
    return allImages;
  }

  // Status helpers
  String get statusText {
    if (!isComplete) return 'البروفايل غير مكتمل';
    if (isVerified && isFeatured) return 'موثق ومميز';
    if (isVerified) return 'موثق';
    if (isFeatured) return 'مميز';
    return 'نشط';
  }

  Color get statusColor {
    if (!isComplete) return Colors.grey;
    if (isVerified && isFeatured) return Colors.purple;
    if (isVerified) return Colors.green;
    if (isFeatured) return Colors.blue;
    return Colors.orange;
  }

  IconData get statusIcon {
    if (!isComplete) return Icons.info;
    if (isVerified && isFeatured) return Icons.star;
    if (isVerified) return Icons.verified;
    if (isFeatured) return Icons.featured_play_list;
    return Icons.person;
  }

  // Service-based helpers (fallback to category)
  IconData getServiceIcon() {
    final catName = categoryName?.toLowerCase() ?? '';

    if (catName.contains('تصوير') || catName.contains('photo')) {
      return Icons.camera_alt;
    } else if (catName.contains('تصميم') || catName.contains('design')) {
      return Icons.brush;
    } else if (catName.contains('طباعة') || catName.contains('print')) {
      return Icons.print;
    } else if (catName.contains('رقمية') || catName.contains('digital')) {
      return Icons.computer;
    }

    return Icons.work;
  }

  Color getServiceColor() {
    final catName = categoryName?.toLowerCase() ?? '';

    if (catName.contains('تصوير') || catName.contains('photo')) {
      return const Color(0xFF3B82F6);
    } else if (catName.contains('تصميم') || catName.contains('design')) {
      return const Color(0xFF10B981);
    } else if (catName.contains('طباعة') || catName.contains('print')) {
      return const Color(0xFF8B5CF6);
    } else if (catName.contains('رقمية') || catName.contains('digital')) {
      return const Color(0xFFEF4444);
    }

    return const Color(0xFF6B7280);
  }

  String getExperienceText() {
    final experienceYears = DateTime.now().difference(createdAt).inDays ~/ 365;

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

  @override
  String toString() {
    return 'ProviderProfile(id: $id, userId: $userId, city: $city, isVerified: $isVerified, isFeatured: $isFeatured, isComplete: $isComplete)';
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