import 'package:equatable/equatable.dart';

class BirthDetailsEntity extends Equatable {
  final String name;
  final DateTime dateOfBirth;
  final double timeOfBirthHour; // decimal hours e.g. 14.5 = 2:30 PM
  final String placeOfBirth;
  final double latitude;
  final double longitude;
  final double timezone; // UTC offset in hours

  const BirthDetailsEntity({
    required this.name,
    required this.dateOfBirth,
    required this.timeOfBirthHour,
    required this.placeOfBirth,
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  int get birthYear => dateOfBirth.year;
  int get birthMonth => dateOfBirth.month;
  int get birthDay => dateOfBirth.day;

  String get formattedDate =>
      '${birthDay.toString().padLeft(2, '0')}/${birthMonth.toString().padLeft(2, '0')}/$birthYear';

  String get formattedTime {
    final hour = timeOfBirthHour.floor();
    final minute = ((timeOfBirthHour - hour) * 60).round();
    final period = hour >= 12 ? 'PM' : 'AM';
    final h12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${h12.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  BirthDetailsEntity copyWith({
    String? name,
    DateTime? dateOfBirth,
    double? timeOfBirthHour,
    String? placeOfBirth,
    double? latitude,
    double? longitude,
    double? timezone,
  }) {
    return BirthDetailsEntity(
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      timeOfBirthHour: timeOfBirthHour ?? this.timeOfBirthHour,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'timeOfBirthHour': timeOfBirthHour,
      'placeOfBirth': placeOfBirth,
      'latitude': latitude,
      'longitude': longitude,
      'timezone': timezone,
    };
  }

  factory BirthDetailsEntity.fromMap(Map<String, dynamic> map) {
    return BirthDetailsEntity(
      name: map['name'] as String,
      dateOfBirth: DateTime.parse(map['dateOfBirth'] as String),
      timeOfBirthHour: (map['timeOfBirthHour'] as num).toDouble(),
      placeOfBirth: map['placeOfBirth'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      timezone: (map['timezone'] as num).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
    name, dateOfBirth, timeOfBirthHour, placeOfBirth, latitude, longitude, timezone,
  ];
}
