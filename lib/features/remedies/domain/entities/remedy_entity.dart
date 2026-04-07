import 'package:equatable/equatable.dart';

class RemedyEntity extends Equatable {
  final String id;
  final String planet;
  final String issue;
  final String gemstone;
  final String mantra;
  final String yantra;
  final String fastingDay;
  final String color;
  final String donation;
  final String description;
  final List<String> categories;
  final String emoji;

  const RemedyEntity({
    required this.id,
    required this.planet,
    required this.issue,
    required this.gemstone,
    required this.mantra,
    required this.yantra,
    required this.fastingDay,
    required this.color,
    required this.donation,
    required this.description,
    required this.categories,
    required this.emoji,
  });

  @override
  List<Object?> get props => [id, planet, issue];
}
