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
      providersCount: json['providers_count'] != null
          ? int.tryParse(json['providers_count'].toString())
          : 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
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

  IconData getServiceIcon() {
    final lowerName = category?.name?.toLowerCase() ?? name.toLowerCase();

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
    // تحرير وتعديل
    else if (lowerName.contains('فوتوشوب') || lowerName.contains('photo editing')) {
      return Icons.tune;
    }
    // برمجة - مواقع
    else if (lowerName.contains('مواقع') || lowerName.contains('website') || lowerName.contains('web')) {
      return Icons.web;
    } else if (lowerName.contains('متجر إلكتروني') || lowerName.contains('e-commerce') || lowerName.contains('store')) {
      return Icons.shopping_cart;
    } else if (lowerName.contains('landing page') || lowerName.contains('صفحة هبوط')) {
      return Icons.web_asset;
    } else if (lowerName.contains('wordpress') || lowerName.contains('ووردبريس')) {
      return Icons.web_stories;
    }
    // برمجة - تطبيقات
    else if (lowerName.contains('تطبيقات موبايل') || lowerName.contains('mobile app') || lowerName.contains('flutter')) {
      return Icons.phone_android;
    } else if (lowerName.contains('تطبيق ios') || lowerName.contains('ios')) {
      return Icons.phone_iphone;
    } else if (lowerName.contains('تطبيق أندرويد') || lowerName.contains('android')) {
      return Icons.android;
    }
    // برمجة - أنظمة وقواعد بيانات
    else if (lowerName.contains('api') || lowerName.contains('backend') || lowerName.contains('خلفية')) {
      return Icons.storage;
    } else if (lowerName.contains('قاعدة بيانات') || lowerName.contains('database')) {
      return Icons.dns;
    } else if (lowerName.contains('نظام إدارة') || lowerName.contains('crm') || lowerName.contains('erp')) {
      return Icons.dashboard;
    }
    // برمجة - عامة
    else if (lowerName.contains('برمجة') || lowerName.contains('programming') || lowerName.contains('development')) {
      return Icons.code;
    } else if (lowerName.contains('سكريبت') || lowerName.contains('script') || lowerName.contains('automation')) {
      return Icons.auto_fix_high;
    }

    return Icons.work; // Default icon
  }

  Color getPrimaryColor() {
    final lowerName = category?.name?.toLowerCase() ?? name.toLowerCase();

    if (lowerName.contains('تصوير مناسبات') || lowerName.contains('event')) {
      return const Color(0xFF9333EA); // بنفسجي
    } else if (lowerName.contains('تصوير منتجات') || lowerName.contains('product')) {
      return const Color(0xFF8B5CF6); // بنفسجي فاتح
    } else if (lowerName.contains('جلسات تصوير') || lowerName.contains('portrait')) {
      return const Color(0xFF6366F1); // نيلي
    } else if (lowerName.contains('فيديو قصير')) {
      return const Color(0xFF3B82F6); // أزرق
    } else if (lowerName.contains('مونتاج') || lowerName.contains('editing')) {
      return const Color(0xFF0EA5E9); // أزرق سماوي
    }
    // تصميم - درجات الوردي والأحمر
    else if (lowerName.contains('شعارات') || lowerName.contains('logo')) {
      return const Color(0xFFDD0971); // وردي
    } else if (lowerName.contains('سوشال ميديا') || lowerName.contains('social')) {
      return const Color(0xFFF43F5E); // أحمر وردي
    } else if (lowerName.contains('هوية بصرية') || lowerName.contains('brand')) {
      return const Color(0xFFEF4444); // أحمر
    } else if (lowerName.contains('كروت') || lowerName.contains('cards')) {
      return const Color(0xFFCD2121); // برتقالي
    } else if (lowerName.contains('بروشورات') || lowerName.contains('brochure')) {
      return const Color(0xFFC11024); // برتقالي ذهبي
    }
    else if (lowerName.contains('طباعة صور') || lowerName.contains('photo printing')) {
      return const Color(0xFF57AA37); // أصفر
    } else if (lowerName.contains('بوسترات') || lowerName.contains('poster')) {
      return const Color(0xFF84CC16); // أخضر ليموني
    } else if (lowerName.contains('تيشيرتات') || lowerName.contains('custom')) {
      return const Color(0xFF22C55E); // أخضر
    } else if (lowerName.contains('كتب') || lowerName.contains('book')) {
      return const Color(0xFF10B981); // أخضر زمردي
    } else if (lowerName.contains('تغليف') || lowerName.contains('binding')) {
      return const Color(0xFF54D557); // فيروزي
    }
    else if (lowerName.contains('فوتوشوب') || lowerName.contains('photo editing')) {
      return const Color(0xFF012D80); // سيان
    }
    else if (lowerName.contains('مواقع') || lowerName.contains('website') || lowerName.contains('web')) {
      return const Color(0xFF0284C7); // أزرق غامق
    } else if (lowerName.contains('متجر إلكتروني') || lowerName.contains('e-commerce') || lowerName.contains('store')) {
      return const Color(0xFF6B8EDA); // أخضر متجر
    } else if (lowerName.contains('landing page') || lowerName.contains('صفحة هبوط')) {
      return const Color(0xFF2740E4); // سيان غامق
    } else if (lowerName.contains('wordpress') || lowerName.contains('ووردبريس')) {
      return const Color(0xFF1673CF); // تيل
    }
    // برمجة - تطبيقات - درجات الأخضر والأزرق
    else if (lowerName.contains('تطبيقات موبايل') || lowerName.contains('mobile app') || lowerName.contains('flutter')) {
      return const Color(0xFF0284C7); // أزرق Flutter
    } else if (lowerName.contains('تطبيق ios') || lowerName.contains('ios')) {
      return const Color(0xFF7697C6); // رمادي مزرق (iOS)
    } else if (lowerName.contains('تطبيق أندرويد') || lowerName.contains('android')) {
      return const Color(0xFF4389C1); // أخضر (Android)
    }

    return const Color(0xFF3702B1);
  }

  String get categoryName => category?.name ?? 'غير محدد';
}
