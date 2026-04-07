import 'package:equatable/equatable.dart';
import 'birth_details_entity.dart';

class PlanetPosition extends Equatable {
  final String planet;
  final double longitude; // 0-360 degrees
  final int rashi; // 0-11 (zodiac sign index)
  final double rashiDegree; // degree within rashi 0-30
  final int nakshatra; // 0-26
  final int nakshatraPada; // 1-4
  final int house; // 1-12
  final bool isRetrograde;
  final bool isCombust;
  final bool isExalted;
  final bool isDebilitated;

  const PlanetPosition({
    required this.planet,
    required this.longitude,
    required this.rashi,
    required this.rashiDegree,
    required this.nakshatra,
    required this.nakshatraPada,
    required this.house,
    this.isRetrograde = false,
    this.isCombust = false,
    this.isExalted = false,
    this.isDebilitated = false,
  });

  Map<String, dynamic> toMap() => {
    'planet': planet,
    'longitude': longitude,
    'rashi': rashi,
    'rashiDegree': rashiDegree,
    'nakshatra': nakshatra,
    'nakshatraPada': nakshatraPada,
    'house': house,
    'isRetrograde': isRetrograde,
    'isCombust': isCombust,
    'isExalted': isExalted,
    'isDebilitated': isDebilitated,
  };

  factory PlanetPosition.fromMap(Map<String, dynamic> m) => PlanetPosition(
    planet: m['planet'] as String,
    longitude: (m['longitude'] as num).toDouble(),
    rashi: m['rashi'] as int,
    rashiDegree: (m['rashiDegree'] as num).toDouble(),
    nakshatra: m['nakshatra'] as int,
    nakshatraPada: m['nakshatraPada'] as int,
    house: m['house'] as int,
    isRetrograde: m['isRetrograde'] as bool? ?? false,
    isCombust: m['isCombust'] as bool? ?? false,
    isExalted: m['isExalted'] as bool? ?? false,
    isDebilitated: m['isDebilitated'] as bool? ?? false,
  );

  @override
  List<Object?> get props => [planet, longitude, rashi, house, isRetrograde];
}

class DashaPeriod extends Equatable {
  final String planet;
  final DateTime startDate;
  final DateTime endDate;
  final int years;
  final List<DashaPeriod> antarDashas;

  const DashaPeriod({
    required this.planet,
    required this.startDate,
    required this.endDate,
    required this.years,
    this.antarDashas = const [],
  });

  bool get isCurrent {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  Map<String, dynamic> toMap() => {
    'planet': planet,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'years': years,
    'antarDashas': antarDashas.map((d) => d.toMap()).toList(),
  };

  factory DashaPeriod.fromMap(Map<String, dynamic> m) => DashaPeriod(
    planet: m['planet'] as String,
    startDate: DateTime.parse(m['startDate'] as String),
    endDate: DateTime.parse(m['endDate'] as String),
    years: m['years'] as int,
    antarDashas: (m['antarDashas'] as List? ?? [])
        .map((d) => DashaPeriod.fromMap(d as Map<String, dynamic>))
        .toList(),
  );

  @override
  List<Object?> get props => [planet, startDate, endDate];
}

class KundliYoga extends Equatable {
  final String name;
  final String description;
  final bool isPresent;
  final List<String> involvedPlanets;

  const KundliYoga({
    required this.name,
    required this.description,
    required this.isPresent,
    required this.involvedPlanets,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
    'isPresent': isPresent,
    'involvedPlanets': involvedPlanets,
  };

  factory KundliYoga.fromMap(Map<String, dynamic> m) => KundliYoga(
    name: m['name'] as String,
    description: m['description'] as String,
    isPresent: m['isPresent'] as bool,
    involvedPlanets: List<String>.from(m['involvedPlanets'] as List),
  );

  @override
  List<Object?> get props => [name, isPresent];
}

class KundliEntity extends Equatable {
  final String id;
  final BirthDetailsEntity birthDetails;
  final int lagnaRashi; // Ascendant sign 0-11
  final double lagnaLongitude; // Ascendant degree 0-360
  final List<PlanetPosition> planetPositions;
  final List<int> houseRashis; // Rashi index for each house (12 elements)
  final List<DashaPeriod> dashas; // Vimshottari dasha periods
  final List<KundliYoga> yogas;
  final DateTime createdAt;
  final String? notes;

  const KundliEntity({
    required this.id,
    required this.birthDetails,
    required this.lagnaRashi,
    required this.lagnaLongitude,
    required this.planetPositions,
    required this.houseRashis,
    required this.dashas,
    required this.yogas,
    required this.createdAt,
    this.notes,
  });

  PlanetPosition? getPlanet(String name) {
    try {
      return planetPositions.firstWhere((p) => p.planet == name);
    } catch (_) {
      return null;
    }
  }

  DashaPeriod? get currentDasha {
    try {
      return dashas.firstWhere((d) => d.isCurrent);
    } catch (_) {
      return null;
    }
  }

  int get moonRashi => getPlanet('Moon')?.rashi ?? 0;
  int get moonNakshatra => getPlanet('Moon')?.nakshatra ?? 0;
  int get sunRashi => getPlanet('Sun')?.rashi ?? 0;

  Map<String, dynamic> toMap() => {
    'id': id,
    'birthDetails': birthDetails.toMap(),
    'lagnaRashi': lagnaRashi,
    'lagnaLongitude': lagnaLongitude,
    'planetPositions': planetPositions.map((p) => p.toMap()).toList(),
    'houseRashis': houseRashis,
    'dashas': dashas.map((d) => d.toMap()).toList(),
    'yogas': yogas.map((y) => y.toMap()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'notes': notes,
  };

  factory KundliEntity.fromMap(Map<String, dynamic> m) => KundliEntity(
    id: m['id'] as String,
    birthDetails: BirthDetailsEntity.fromMap(m['birthDetails'] as Map<String, dynamic>),
    lagnaRashi: m['lagnaRashi'] as int,
    lagnaLongitude: (m['lagnaLongitude'] as num).toDouble(),
    planetPositions: (m['planetPositions'] as List)
        .map((p) => PlanetPosition.fromMap(p as Map<String, dynamic>))
        .toList(),
    houseRashis: List<int>.from(m['houseRashis'] as List),
    dashas: (m['dashas'] as List)
        .map((d) => DashaPeriod.fromMap(d as Map<String, dynamic>))
        .toList(),
    yogas: (m['yogas'] as List)
        .map((y) => KundliYoga.fromMap(y as Map<String, dynamic>))
        .toList(),
    createdAt: DateTime.parse(m['createdAt'] as String),
    notes: m['notes'] as String?,
  );

  @override
  List<Object?> get props => [id, birthDetails, createdAt];
}
