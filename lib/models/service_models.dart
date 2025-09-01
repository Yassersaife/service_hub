// lib/models/service_models.dart - Updated to match real API
import 'package:flutter/material.dart';

class Service {
  final int id;
  final String name;
  final String? nameEn;
  final String slug;
  final String? description;
  final String? icon;
  final bool isActive;
  final int sortOrder;
  final int? categoryId;
  final ServiceCategory? category; // العلاقة مع التخصص
  final int? providersCount; // عدد مقدمي الخدمة
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Service({
    required this.id,
    required this.name,
    this.nameEn,
    required this.slug,
    this.description,
    this.icon,
    required this.isActive,
    required this.sortOrder,
    this.categoryId,
    this.category,
    this.providersCount,
    this.createdAt,
    this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      nameEn: json['name_en'],
      slug: json['slug'],
      description: json['description'],
      icon: json['icon'],
      isActive: json['is_active'] ?? false,
      sortOrder: json['sort_order'] ?? 0,
      categoryId: json['category_id'],
      category: json['category'] != null
          ? ServiceCategory.fromJson(json['category'])
          : null,
      providersCount: json['providers_count'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'slug': slug,
      'description': description,
      'icon': icon,
      'is_active': isActive,
      'sort_order': sortOrder,
      'category_id': categoryId,
      'category': category?.toJson(),
      'providers_count': providersCount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // إنشاء نسخة جديدة مع تغيير بعض الخصائص
  Service copyWith({
    int? id,
    String? name,
    String? nameEn,
    String? slug,
    String? description,
    String? icon,
    bool? isActive,
    int? sortOrder,
    int? categoryId,
    ServiceCategory? category,
    int? providersCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      providersCount: providersCount ?? this.providersCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  IconData getIcon() {
    // استخدام icon من API أولاً
    if (icon != null && icon!.isNotEmpty) {
      switch (icon!) {
        case 'fas fa-code':
        case 'code':
          return Icons.code;
        case 'fas fa-globe':
        case 'globe':
          return Icons.language;
        case 'fas fa-mobile':
        case 'mobile':
          return Icons.phone_android;
        case 'fas fa-desktop':
        case 'desktop':
          return Icons.desktop_windows;
        case 'fas fa-camera':
        case 'camera':
          return Icons.camera_alt;
        case 'fas fa-video':
        case 'video':
          return Icons.videocam;
        case 'fas fa-palette':
        case 'palette':
          return Icons.palette;
        case 'fas fa-print':
        case 'print':
          return Icons.print;
      }
    }

    // استخدام الـ slug كـ fallback
    switch (slug.toLowerCase()) {
      case 'web-development':
      case 'تطوير-الويب':
        return Icons.language;
      case 'mobile-app':
      case 'تطبيقات-الجوال':
        return Icons.phone_android;
      case 'desktop-app':
      case 'تطبيقات-سطح-المكتب':
        return Icons.desktop_windows;
      case 'event-photography':
      case 'تصوير-الفعاليات':
        return Icons.celebration;
      case 'product-photography':
      case 'تصوير-المنتجات':
        return Icons.inventory_2;
      case 'portrait-photography':
      case 'التصوير-الشخصي':
        return Icons.portrait;
      case 'video-production':
      case 'إنتاج-الفيديو':
        return Icons.video_camera_front;
      case 'video-editing':
      case 'مونتاج-الفيديو':
        return Icons.video_settings;
      case 'logo-design':
      case 'تصميم-الشعارات':
        return Icons.logo_dev;
      case 'social-media-design':
      case 'تصميم-وسائل-التواصل':
        return Icons.share;
      case 'brand-identity':
      case 'الهوية-التجارية':
        return Icons.branding_watermark;
      case 'business-cards':
      case 'بطاقات-العمل':
        return Icons.badge;
      case 'brochure-design':
      case 'تصميم-البروشور':
        return Icons.description;
      case 'photo-printing':
      case 'طباعة-الصور':
        return Icons.photo_camera;
      case 'poster-printing':
      case 'طباعة-الملصقات':
        return Icons.campaign;
      case 'custom-printing':
      case 'الطباعة-المخصصة':
        return Icons.checkroom;
      case 'book-printing':
      case 'طباعة-الكتب':
        return Icons.menu_book;
      case 'binding-packaging':
      case 'التجليد-والتغليف':
        return Icons.inventory;
      case 'photo-editing':
      case 'تحرير-الصور':
        return Icons.tune;
      case 'website-design':
      case 'تصميم-المواقع':
        return Icons.web;
      default:
        return Icons.work;
    }
  }
}

class ServiceCategory {
  final int id;
  final String name;
  final String? nameEn;
  final String slug;
  final String? icon;
  final String? color;
  final List<String>? gradientColors;
  final String? description;
  final bool isActive;
  final int sortOrder;
  final List<Service>? services; // الخدمات المرتبطة
  final List<Service>? activeServices; // الخدمات المفعلة فقط
  final int? servicesCount; // العدد الكلي للخدمات
  final int? activeServicesCount; // العدد الكلي للخدمات المفعلة
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ServiceCategory({
    required this.id,
    required this.name,
    this.nameEn,
    required this.slug,
    this.icon,
    this.color,
    this.gradientColors,
    this.description,
    required this.isActive,
    required this.sortOrder,
    this.services,
    this.activeServices,
    this.servicesCount,
    this.activeServicesCount,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'],
      name: json['name'],
      nameEn: json['name_en'],
      slug: json['slug'],
      icon: json['icon'],
      color: json['color'],
      gradientColors: json['gradient_colors'] != null
          ? List<String>.from(json['gradient_colors'])
          : null,
      description: json['description'],
      isActive: json['is_active'] ?? false,
      sortOrder: json['sort_order'] ?? 0,
      services: json['services'] != null
          ? (json['services'] as List)
          .map((service) => Service.fromJson(service))
          .toList()
          : null,
      activeServices: json['active_services'] != null
          ? (json['active_services'] as List)
          .map((service) => Service.fromJson(service))
          .toList()
          : null,
      servicesCount: json['services_count'],
      activeServicesCount: json['active_services_count'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_en': nameEn,
      'slug': slug,
      'icon': icon,
      'color': color,
      'gradient_colors': gradientColors,
      'description': description,
      'is_active': isActive,
      'sort_order': sortOrder,
      'services': services?.map((service) => service.toJson()).toList(),
      'active_services': activeServices?.map((service) => service.toJson()).toList(),
      'services_count': servicesCount,
      'active_services_count': activeServicesCount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // إنشاء نسخة جديدة مع تغيير بعض الخصائص
  ServiceCategory copyWith({
    int? id,
    String? name,
    String? nameEn,
    String? slug,
    String? icon,
    String? color,
    List<String>? gradientColors,
    String? description,
    bool? isActive,
    int? sortOrder,
    List<Service>? services,
    List<Service>? activeServices,
    int? servicesCount,
    int? activeServicesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      slug: slug ?? this.slug,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      gradientColors: gradientColors ?? this.gradientColors,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      services: services ?? this.services,
      activeServices: activeServices ?? this.activeServices,
      servicesCount: servicesCount ?? this.servicesCount,
      activeServicesCount: activeServicesCount ?? this.activeServicesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  IconData getCategoryIcon() {
    // استخدام الـ icon field من API أولاً
    if (icon != null && icon!.isNotEmpty) {
      switch (icon!.toLowerCase()) {
        case 'fas fa-camera':
        case 'camera':
        case 'camera_alt':
          return Icons.camera_alt;
        case 'fas fa-palette':
        case 'palette':
          return Icons.palette;
        case 'fas fa-print':
        case 'print':
          return Icons.print;
        case 'fas fa-computer':
        case 'fas fa-laptop':
        case 'computer':
        case 'laptop':
          return Icons.computer;
        case 'fas fa-code':
        case 'code':
          return Icons.code;
        case 'fas fa-brush':
        case 'brush':
          return Icons.brush;
        case 'fas fa-video':
        case 'video':
          return Icons.videocam;
      }
    }

    // Fallback حسب الـ slug
    switch (slug.toLowerCase()) {
      case 'photography-production':
      case 'التصوير-والإنتاج':
        return Icons.camera_alt;
      case 'design-graphics':
      case 'التصميم-والجرافيك':
        return Icons.brush;
      case 'printing-office':
      case 'الطباعة-والمكتب':
        return Icons.print;
      case 'digital-services':
      case 'الخدمات-الرقمية':
        return Icons.computer;
      case 'programming-development':
      case 'البرمجة-والتطوير':
        return Icons.code;
      case 'video-production':
      case 'إنتاج-الفيديو':
        return Icons.videocam;
      default:
        return Icons.category;
    }
  }

  Color getPrimaryColor() {
    if (color == null || color!.isEmpty) {
      return const Color(0xFF3B82F6); // اللون الافتراضي
    }

    try {
      String colorHex = color!;
      if (!colorHex.startsWith('#')) {
        colorHex = '#$colorHex';
      }
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return const Color(0xFF3B82F6); // اللون الافتراضي في حالة خطأ
    }
  }

  List<Color> getGradientColors() {
    if (gradientColors == null || gradientColors!.isEmpty) {
      return [
        const Color(0xFF3B82F6),
        const Color(0xFF1E40AF),
      ]; // الألوان الافتراضية
    }

    try {
      return gradientColors!.map((colorHex) {
        String hex = colorHex;
        if (!hex.startsWith('#')) {
          hex = '#$hex';
        }
        return Color(int.parse(hex.replaceFirst('#', '0xFF')));
      }).toList();
    } catch (e) {
      return [
        const Color(0xFF3B82F6),
        const Color(0xFF1E40AF),
      ]; // الألوان الافتراضية في حالة خطأ
    }
  }

  LinearGradient getLinearGradient() {
    final colors = getGradientColors();
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // الحصول على الخدمات المفعلة (أولوية للقائمة المنفصلة ثم الفلترة)
  List<Service> getActiveServices() {
    if (activeServices != null) {
      return activeServices!;
    } else if (services != null) {
      return services!.where((service) => service.isActive).toList();
    } else {
      return [];
    }
  }

  // التحقق من وجود خدمات
  bool get hasServices {
    return (activeServicesCount ?? 0) > 0 || getActiveServices().isNotEmpty;
  }
}