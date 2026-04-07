import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final DateTime createdAt;
  final bool isPremium;
  final DateTime? premiumExpiry;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    required this.createdAt,
    this.isPremium = false,
    this.premiumExpiry,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    DateTime? createdAt,
    bool? isPremium,
    DateTime? premiumExpiry,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiry: premiumExpiry ?? this.premiumExpiry,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'isPremium': isPremium,
      'premiumExpiry': premiumExpiry?.toIso8601String(),
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String?,
      photoUrl: map['photoUrl'] as String?,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'] as String)
          : DateTime.now(),
      isPremium: map['isPremium'] as bool? ?? false,
      premiumExpiry: map['premiumExpiry'] != null
          ? DateTime.parse(map['premiumExpiry'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [
    id, name, email, phone, photoUrl, createdAt, isPremium, premiumExpiry,
  ];
}
