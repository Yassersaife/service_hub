import 'package:flutter/material.dart';
import 'category.dart';

class Service {
  final int id;
  final int categoryId;
  final String name;
  final int? providersCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Category? category;

  Service({
    required this.id,
    required this.categoryId,
    required this.name,
    this.providersCount,
    required this.createdAt,
    required this.updatedAt,
    this.category,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      categoryId: json['category_id'] is int
          ? json['category_id']
          : int.parse(json['category_id'].toString()),
      name: json['name'] ?? '',
      providersCount: json['providers_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'providers_count': providersCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'category': category?.toJson(),
    };
  }

  Service copyWith({
    int? id,
    int? categoryId,
    String? name,
    int? providersCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    Category? category,
  }) {
    return Service(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      providersCount: providersCount ?? this.providersCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
    );
  }

  // Helper methods
  bool get hasProviders => (providersCount ?? 0) > 0;

  // Get icon based on service name
  IconData getServiceIcon() {
    final lowerName = name.toLowerCase();

    // تصوير
    if (lowerName.contains('تصوير مناسبات') || lowerName.contains('event')) {
      return Icons.celebration;
    } else if (lowerName.contains('تصوير منتجات') || lowerName.contains('product')) {
      return Icons.inventory_2;
    } else if (lowerName.contains('جلسات تصوير') || lowerName.contains('portrait')) {
      return Icons.portrait;
    } else if (lowerName.contains('فيديو قصير')) {
      return Icons.video_camera_front;
    } else if (lowerName.contains('مونتاج') || lowerName.contains('editing')) {
      return Icons.video_settings;
    }
    // تصميم
    else if (lowerName.contains('شعارات') || lowerName.contains('logo')) {
      return Icons.logo_dev;
    } else if (lowerName.contains('سوشال ميديا') || lowerName.contains('social')) {
      return Icons.share;
    } else if (lowerName.contains('هوية بصرية') || lowerName.contains('brand')) {
      return Icons.branding_watermark;
    } else if (lowerName.contains('كروت') || lowerName.contains('cards')) {
      return Icons.badge;
    } else if (lowerName.contains('بروشورات') || lowerName.contains('brochure')) {
      return Icons.description;
    }
    // طباعة
    else if (lowerName.contains('طباعة صور') || lowerName.contains('photo printing')) {
      return Icons.photo_camera;
    } else if (lowerName.contains('بوسترات') || lowerName.contains('poster')) {
      return Icons.campaign;
    } else if (lowerName.contains('تيشيرتات') || lowerName.contains('custom')) {
      return Icons.checkroom;
    } else if (lowerName.contains('كتب') || lowerName.contains('book')) {
      return Icons.menu_book;
    } else if (lowerName.contains('تغليف') || lowerName.contains('binding')) {
      return Icons.inventory;
    }
    // رقمية
    else if (lowerName.contains('فوتوشوب') || lowerName.contains('photo editing')) {
      return Icons.tune;
    } else if (lowerName.contains('مواقع') || lowerName.contains('website')) {
      return Icons.web;
    }

    return Icons.work; // Default icon
  }

  // Get color based on category
  Color getPrimaryColor() {
    return category?.getPrimaryColor() ?? const Color(0xFF6B7280);
  }

  String get categoryName => category?.name ?? 'غير محدد';
}