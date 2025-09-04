import 'package:flutter/material.dart';
import 'service.dart';

class Category {
  final int id;
  final String name;
  final int? servicesCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Service>? services; // الخدمات المرتبطة

  Category({
    required this.id,
    required this.name,
    this.servicesCount,
    required this.createdAt,
    required this.updatedAt,
    this.services,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      servicesCount: json['services_count'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      services: json['services'] != null
          ? (json['services'] as List)
          .map((service) => Service.fromJson(service))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'services_count': servicesCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'services': services?.map((service) => service.toJson()).toList(),
    };
  }

  Category copyWith({
    int? id,
    String? name,
    int? servicesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Service>? services,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      servicesCount: servicesCount ?? this.servicesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      services: services ?? this.services,
    );
  }

  // Helper methods
  bool get hasServices => (servicesCount ?? 0) > 0;

  // Icon based on category name
  IconData getCategoryIcon() {
    final lowerName = name.toLowerCase();

    if (lowerName.contains('تصوير') || lowerName.contains('photo')) {
      return Icons.camera_alt;
    } else if (lowerName.contains('تصميم') || lowerName.contains('design')) {
      return Icons.brush;
    } else if (lowerName.contains('طباعة') || lowerName.contains('print')) {
      return Icons.print;
    } else if (lowerName.contains('رقمية') || lowerName.contains('digital')) {
      return Icons.computer;
    } else if (lowerName.contains('برمجة') || lowerName.contains('program')) {
      return Icons.code;
    } else if (lowerName.contains('فيديو') || lowerName.contains('video')) {
      return Icons.videocam;
    }

    return Icons.category;
  }

  // Color based on category name
  Color getPrimaryColor() {
    final lowerName = name.toLowerCase();

    if (lowerName.contains('تصوير') || lowerName.contains('photo')) {
      return const Color(0xFF3B82F6); // Blue
    } else if (lowerName.contains('تصميم') || lowerName.contains('design')) {
      return const Color(0xFF10B981); // Green
    } else if (lowerName.contains('طباعة') || lowerName.contains('print')) {
      return const Color(0xFF8B5CF6); // Purple
    } else if (lowerName.contains('رقمية') || lowerName.contains('digital')) {
      return const Color(0xFFEF4444); // Red
    }

    return const Color(0xFF6B7280); // Gray default
  }

  LinearGradient getLinearGradient() {
    final primaryColor = getPrimaryColor();
    return LinearGradient(
      colors: [
        primaryColor,
        primaryColor.withOpacity(0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}