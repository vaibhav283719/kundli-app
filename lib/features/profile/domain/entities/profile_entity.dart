import 'package:equatable/equatable.dart';
import '../../../kundli/domain/entities/birth_details_entity.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String name;
  final BirthDetailsEntity? birthDetails;
  final DateTime createdAt;
  final String? photoUrl;
  final String? notes;
  final bool isPrimary;

  const ProfileEntity({
    required this.id,
    required this.name,
    this.birthDetails,
    required this.createdAt,
    this.photoUrl,
    this.notes,
    this.isPrimary = false,
  });

  ProfileEntity copyWith({
    String? id,
    String? name,
    BirthDetailsEntity? birthDetails,
    DateTime? createdAt,
    String? photoUrl,
    String? notes,
    bool? isPrimary,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDetails: birthDetails ?? this.birthDetails,
      createdAt: createdAt ?? this.createdAt,
      photoUrl: photoUrl ?? this.photoUrl,
      notes: notes ?? this.notes,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthDetails': birthDetails?.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'photoUrl': photoUrl,
      'notes': notes,
      'isPrimary': isPrimary,
    };
  }

  factory ProfileEntity.fromMap(Map<String, dynamic> map) {
    return ProfileEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      birthDetails: map['birthDetails'] != null
          ? BirthDetailsEntity.fromMap(map['birthDetails'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(map['createdAt'] as String),
      photoUrl: map['photoUrl'] as String?,
      notes: map['notes'] as String?,
      isPrimary: map['isPrimary'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, name, createdAt];
}
