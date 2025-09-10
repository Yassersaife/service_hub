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
      'provider_profile': providerProfile?.toJson(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      userType: json['user_type'] ?? 'customer',
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      providerProfile: json['provider_profile'] != null
          ? ProviderProfile.fromJson(json['provider_profile'])
          : null,
    );
  }
}