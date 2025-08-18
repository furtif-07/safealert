import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String role;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final Map<String, dynamic>? preferences;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    required this.role,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.preferences,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        role,
        profileImageUrl,
        createdAt,
        updatedAt,
        isActive,
        preferences,
      ];

  UserEntity copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? role,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    Map<String, dynamic>? preferences,
  }) {
    return UserEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      preferences: preferences ?? this.preferences,
    );
  }
}