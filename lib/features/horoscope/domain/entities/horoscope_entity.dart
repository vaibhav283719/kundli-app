import 'package:equatable/equatable.dart';

class HoroscopeEntity extends Equatable {
  final String zodiacSign;
  final String zodiacSignHindi;
  final DateTime date;
  final String prediction;
  final String love;
  final String career;
  final String health;
  final String finance;
  final int luckyNumber;
  final String luckyColor;
  final String luckyGem;
  final List<String> compatibleSigns;
  final int rating; // 1-5 stars

  const HoroscopeEntity({
    required this.zodiacSign,
    required this.zodiacSignHindi,
    required this.date,
    required this.prediction,
    required this.love,
    required this.career,
    required this.health,
    required this.finance,
    required this.luckyNumber,
    required this.luckyColor,
    required this.luckyGem,
    required this.compatibleSigns,
    required this.rating,
  });

  @override
  List<Object?> get props => [zodiacSign, date];
}
