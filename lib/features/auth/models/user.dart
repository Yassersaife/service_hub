class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime createdAt;
  final bool isEmailVerified;
  final UserType userType;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    this.isEmailVerified = false,
    required this.userType,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    DateTime? createdAt,
    bool? isEmailVerified,
    UserType? userType,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      userType: userType ?? this.userType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'isEmailVerified': isEmailVerified,
      'userType': userType.toString(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      createdAt: DateTime.parse(json['createdAt']),
      isEmailVerified: json['isEmailVerified'] ?? false,
      userType: UserType.values.firstWhere(
            (e) => e.toString() == json['userType'],
      ),
    );
  }
}

enum UserType {
  customer,
  serviceProvider,
}
