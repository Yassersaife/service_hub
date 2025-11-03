// lib/models/user.dart

import 'package:Lumixy/features/service_provider/models/provider_profile.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String userType;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProviderProfile? providerProfile;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.providerProfile,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? userType,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    ProviderProfile? providerProfile,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      providerProfile: providerProfile ?? this.providerProfile,
    );
  }

  // Helper getters
  bool get isEmailVerified => emailVerifiedAt != null;
  bool get isProvider => userType == 'provider';
  bool get isCustomer => userType == 'customer';
  bool get hasProviderProfile => providerProfile != null;
  bool get hasCompleteProfile => providerProfile?.isComplete ?? false;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'user_type': userType,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      // ✅ التعديل - تحقق من وجود providerProfile قبل استدعاء toJson
      if (providerProfile != null)
        'provider_profile': _providerProfileToJson(providerProfile!),
    };
  }

  // ✅ Helper method لتحويل ProviderProfile إلى JSON
  Map<String, dynamic> _providerProfileToJson(ProviderProfile profile) {
    return {
      'id': profile.id,
      'user_id': profile.userId,
      'category_id': profile.categoryId,
      'address': profile.address,
      'city': profile.city,
      'description': profile.description,
      'profile_image': profile.profileImage,
      'work_hours': profile.workHours,
      'whatsapp_number': profile.whatsappNumber,
      'is_verified': profile.isVerified,
      'is_featured': profile.isFeatured,
      'is_complete': profile.isComplete,
      'social_media': profile.socialMedia,
      'created_at': profile.createdAt.toIso8601String(),
      'updated_at': profile.updatedAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    try {
      return User(
        id: _parseInt(json['id']),
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        userType: json['user_type']?.toString() ?? 'customer',
        emailVerifiedAt: _parseDateTime(json['email_verified_at']),
        createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
        updatedAt: _parseDateTime(json['updated_at']) ?? DateTime.now(),
        providerProfile: _parseProviderProfile(json['provider_profile']),
      );
    } catch (e, stackTrace) {
      print('Error parsing User from JSON: $e');
      print('Stack trace: $stackTrace');
      print('JSON data: $json');
      rethrow;
    }
  }

  // ✅ Helper methods للتحويل الآمن
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      if (value is String) return DateTime.parse(value);
      if (value is DateTime) return value;
    } catch (e) {
      print('Error parsing datetime: $e');
    }
    return null;
  }

  static ProviderProfile? _parseProviderProfile(dynamic value) {
    if (value == null) return null;
    try {
      if (value is Map<String, dynamic>) {
        return ProviderProfile.fromJson(value);
      }
    } catch (e) {
      print('Error parsing ProviderProfile: $e');
    }
    return null;
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, userType: $userType, hasProfile: $hasProviderProfile)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}