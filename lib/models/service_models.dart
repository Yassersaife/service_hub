// lib/models/service_models.dart - Updated to match real API
import 'package:flutter/material.dart';

class Service {
  final int id;
  final String name;
  final String nameEn;
  final String slug;
  final String description;
  final String? icon;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  Service({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.slug,
    required this.description,
    this.icon,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      nameEn: json['name_en'],
      slug: json['slug'],
      description: json['description'],
      icon: json['icon'],
      isActive: json['is_active'],
      sortOrder: json['sort_order'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  IconData getIcon() {
    // استخدام الـ slug لتحديد الأيقونة
    switch (slug) {
      case 'event-photography':
        return Icons.celebration;
      case 'product-photography':
        return Icons.inventory_2;
      case 'portrait-photography':
        return Icons.portrait;
      case 'short-video':
        return Icons.video_camera_front;
      case 'video-editing':
        return Icons.video_settings;
      case 'logo-design':
        return Icons.logo_dev;
      case 'social-media-design':
        return Icons.share;
      case 'brand-identity':
        return Icons.branding_watermark;
      case 'business-cards':
        return Icons.badge;
      case 'brochure-design':
        return Icons.description;
      case 'photo-printing':
        return Icons.photo_camera;
      case 'poster-printing':
        return Icons.campaign;
      case 'custom-printing':
        return Icons.checkroom;
      case 'book-printing':
        return Icons.menu_book;
      case 'binding-packaging':
        return Icons.inventory;
      case 'photo-editing':
        return Icons.tune;
      case 'website-design':
        return Icons.web;
      default:
        return Icons.work;
    }
  }
}

class ServiceCategory {
  final int id;
  final String name;
  final String nameEn;
  final String slug;
  final String icon;
  final String color;
  final List<String> gradientColors;
  final String description;
  final bool isActive;
  final int sortOrder;
  final List<Service> services;
  final int servicesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceCategory({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.slug,
    required this.icon,
    required this.color,
    required this.gradientColors,
    required this.description,
    required this.isActive,
    required this.sortOrder,
    required this.services,
    required this.servicesCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'],
      name: json['name'],
      nameEn: json['name_en'],
      slug: json['slug'],
      icon: json['icon'],
      color: json['color'],
      gradientColors: List<String>.from(json['gradient_colors']),
      description: json['description'],
      isActive: json['is_active'],
      sortOrder: json['sort_order'],
      services: (json['services'] as List? ?? [])
          .map((service) => Service.fromJson(service))
          .toList(),
      servicesCount: json['services_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
      'services': services.map((service) => service.toJson()).toList(),
      'services_count': servicesCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  IconData getCategoryIcon() {
    // استخدام الـ icon field من API أو fallback للـ slug
    switch (icon) {
      case 'camera_alt':
        return Icons.camera_alt;
      case 'palette':
        return Icons.palette;
      case 'print':
        return Icons.print;
      case 'computer':
        return Icons.computer;
      default:
      // Fallback حسب الـ slug
        switch (slug) {
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
  }

  Color getPrimaryColor() {
    try {
      return Color(int.parse(color.replaceFirst('#', '0xFF')));
    } catch (e) {
      return const Color(0xFF3B82F6); // اللون الافتراضي
    }
  }

  List<Color> getGradientColors() {
    try {
      return gradientColors
          .map((colorHex) => Color(int.parse(colorHex.replaceFirst('#', '0xFF'))))
          .toList();
    } catch (e) {
      return [
        const Color(0xFF3B82F6),
        const Color(0xFF1E40AF),
      ]; // الألوان الافتراضية
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
}