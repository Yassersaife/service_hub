// lib/features/service_provider/models/provider_profile.dart

import 'package:Lumixy/models/service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'portfolio_image.dart';

class ProviderProfile {
  final int id;
  final int userId;
  final int? categoryId;
  final String? address;
  final String city;
  final String? description;
  final String? profileImage;
  final String? profileImageUrl;
  final List<PortfolioImage>? portfolioImages;
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
  final List<Service>? services;

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

  factory ProviderProfile.fromJson(Map<String, dynamic> json) {
    try {
      List<PortfolioImage>? portfolioImages;
      if (json['portfolio_images'] != null && json['portfolio_images'] is List) {
        final list = json['portfolio_images'] as List;
        portfolioImages = list
            .map((item) {
          try {
            return PortfolioImage.fromJson(item as Map<String, dynamic>);
          } catch (e) {
            print('خطأ في تحليل portfolio image: $e');
            return null;
          }
        })
            .where((item) => item != null)
            .cast<PortfolioImage>()
            .toList();
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
        workHours: json['work_hours']?.toString(),
        whatsappNumber: json['whatsapp_number']?.toString(),
        isVerified: _parseToBool(json['is_verified']),
        isFeatured: _parseToBool(json['is_featured']),
        isComplete: _parseToBool(json['is_complete']),
        socialMedia: _parseSocialMedia(json['social_media']),
        createdAt: _parseDateTime(json['created_at']),
        updatedAt: _parseDateTime(json['updated_at']),
        user: json['user'] != null ? Map<String, dynamic>.from(json['user']) : null,
        category: json['category'] != null ? Map<String, dynamic>.from(json['category']) : null,
        services: _parseServices(json['services']),
        servicesCount: json['services_count'] != null ? _parseToInt(json['services_count']) : null,
        status: json['status'] != null ? Map<String, dynamic>.from(json['status']) : null,
        displayInfo: json['display_info'] != null ? Map<String, dynamic>.from(json['display_info']) : null,
      );
    } catch (e, stackTrace) {
      print('Error in ProviderProfile.fromJson: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static bool _parseToBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    if (value is int) return value == 1;
    return false;
  }

  static Map<String, dynamic>? _parseSocialMedia(dynamic value) {
    if (value == null) return null;
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is String && value.isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (e) {
        print('Error parsing social_media: $e');
      }
    }
    return null;
  }

  static List<Service>? _parseServices(dynamic value) {
    print(value);
print("---=-=-=-=-=");
    if (value == null) return null;
    if (value is! List) return null;

    return (value as List)
        .map((item) {
      try {
        return Service.fromJson(item as Map<String, dynamic>);
      } catch (e) {
        print('خطأ في تحليل service: $e');
        return null;
      }
    })
        .where((item) => item != null)
        .cast<Service>()
        .toList();
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      print('Error parsing datetime: $e');
      return DateTime.now();
    }
  }

  String? get userName => user?['name']?.toString() ?? displayInfo?['full_name']?.toString();
  String? get userEmail => user?['email']?.toString();
  String? get userPhone => user?['phone']?.toString() ?? displayInfo?['contact_phone']?.toString();
  String get displayName => userName ?? 'مقدم خدمة';

  String? get categoryName => category?['name']?.toString();

  int get totalServices => servicesCount ?? services?.length ?? 0;
  bool get hasServices => totalServices > 0;
  bool get hasPortfolio => portfolioImages?.isNotEmpty ?? false;

  List<String> get allPortfolioImageUrls {
    if (portfolioImages == null || portfolioImages!.isEmpty) return [];
    return portfolioImages!.map((img) => img.imageUrl).toList();
  }

  int get portfolioCount => portfolioImages?.length ?? 0;

  // ✨ Service Helper Methods
  List<String> get serviceNames =>
      services?.map((s) => s.name).toList() ?? [];

  List<int> get serviceIds =>
      services?.map((s) => s.id).toList() ?? [];

  String get servicesDisplay =>
      serviceNames.isEmpty ? 'لا توجد خدمات' : serviceNames.join(' • ');

  bool hasService(int serviceId) =>
      services?.any((s) => s.id == serviceId) ?? false;

  List<Service> get activeServices =>
      services?.where((s) => s.hasProviders).toList() ?? [];
  // ✨ End Service Helper Methods

  Map<String, dynamic> get socialMediaData => socialMedia ?? {};
  String? get instagramHandle => socialMediaData['instagram']?.toString();
  String? get websiteUrl => socialMediaData['website']?.toString();

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

  String get location => displayInfo?['location']?.toString() ?? city;
  String? get whatsappContact => displayInfo?['whatsapp']?.toString() ?? whatsappNumber;

  IconData getServiceIcon() {
    final catName = categoryName?.toLowerCase() ?? '';

    if (catName.contains('تصوير') || catName.contains('photo')) {
      return Icons.camera_alt;
    } else if (catName.contains('تصميم') || catName.contains('design') || catName.contains('جرافيك')) {
      return Icons.brush;
    } else if (catName.contains('طباعة') || catName.contains('print')) {
      return Icons.print;
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
    } else if (catName.contains('برمجة') || catName.contains('تطوير')) {
      return const Color(0xFF1D4ED8);
    } else if (catName.contains('موقع') || catName.contains('ويب')) {
      return const Color(0xFF059669);
    }

    return const Color(0xFF6B7280);
  }

  String getExperienceText() {
    final experienceYears = DateTime.now().difference(createdAt).inDays ~/ 365;

    if (experienceYears == 0) return 'أقل من سنة';
    if (experienceYears == 1) return 'سنة واحدة';
    if (experienceYears == 2) return 'سنتان';
    if (experienceYears <= 10) return '$experienceYears سنوات';
    return 'أكثر من 10 سنوات';
  }

  @override
  String toString() {
    return 'ProviderProfile(id: $id, userId: $userId, name: $userName, city: $city)';
  }

  ProviderProfile copyWith({
    int? id,
    int? userId,
    int? categoryId,
    String? address,
    String? city,
    String? description,
    String? profileImage,
    String? profileImageUrl,
    List<PortfolioImage>? portfolioImages,
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
    List<Service>? services,
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ProviderProfile &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}