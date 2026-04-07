import 'package:equatable/equatable.dart';

class KootaResult extends Equatable {
  final String name;
  final int maxPoints;
  final int obtainedPoints;
  final String description;
  final bool isCompatible;

  const KootaResult({
    required this.name,
    required this.maxPoints,
    required this.obtainedPoints,
    required this.description,
    required this.isCompatible,
  });

  double get percentage => maxPoints > 0 ? obtainedPoints / maxPoints : 0;

  Map<String, dynamic> toMap() => {
    'name': name,
    'maxPoints': maxPoints,
    'obtainedPoints': obtainedPoints,
    'description': description,
    'isCompatible': isCompatible,
  };

  @override
  List<Object?> get props => [name, obtainedPoints, maxPoints];
}

class CompatibilityEntity extends Equatable {
  final String person1Name;
  final int person1Nakshatra;
  final int person1NakshatraPada;
  final String person2Name;
  final int person2Nakshatra;
  final int person2NakshatraPada;
  final List<KootaResult> kootaResults;
  final DateTime calculatedAt;

  const CompatibilityEntity({
    required this.person1Name,
    required this.person1Nakshatra,
    required this.person1NakshatraPada,
    required this.person2Name,
    required this.person2Nakshatra,
    required this.person2NakshatraPada,
    required this.kootaResults,
    required this.calculatedAt,
  });

  int get totalScore =>
      kootaResults.fold(0, (sum, k) => sum + k.obtainedPoints);

  int get maxScore =>
      kootaResults.fold(0, (sum, k) => sum + k.maxPoints);

  double get percentage => maxScore > 0 ? totalScore / maxScore : 0;

  String get interpretation {
    if (totalScore >= 28) return 'Excellent Match';
    if (totalScore >= 21) return 'Good Match';
    if (totalScore >= 14) return 'Average Match';
    return 'Poor Match';
  }

  String get interpretation_hi {
    if (totalScore >= 28) return 'उत्तम मिलान';
    if (totalScore >= 21) return 'अच्छा मिलान';
    if (totalScore >= 14) return 'सामान्य मिलान';
    return 'कमज़ोर मिलान';
  }

  @override
  List<Object?> get props => [
    person1Name, person2Name, totalScore, calculatedAt,
  ];
}
