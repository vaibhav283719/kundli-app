import '../entities/compatibility_entity.dart';
import '../../../../config/constants/app_constants.dart';

/// Complete Gun Milan (Ashta Koota) calculator
/// Implements all 8 kootas with traditional Vedic astrology rules
class GunMilanCalculator {
  // Nakshatra to Varna mapping (0=Brahmin, 1=Kshatriya, 2=Vaishya, 3=Shudra)
  static const List<int> _nakshatraVarna = [
    2, 3, 1, 2, 1, 3, 0, 2, 3, 1, 2, 1, 3, 2, 1, 0, 2, 3, 3, 1, 2, 1, 2, 3, 0, 2, 1,
  ];

  // Nakshatra to Vashya (animal/sign dominance) 0-4
  static const List<int> _nakshatraVashya = [
    0, 4, 1, 0, 0, 4, 2, 2, 2, 3, 3, 3, 1, 1, 1, 3, 3, 3, 0, 0, 0, 1, 2, 4, 4, 4, 0,
  ];

  // Nakshatra to Yoni animal (0-13)
  static const List<int> _nakshatraYoni = [
    0, 7, 7, 11, 11, 13, 13, 5, 5, 8, 8, 3, 3, 6, 6, 4, 4, 9, 9, 12, 12, 10, 10, 2, 2, 0, 14,
  ];

  // Male/Female Yoni animals (0=male, 1=female) for yoni compatibility
  static const List<int> _yoniGender = [
    0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
  ];

  // Nakshatra to Gana (0=Deva, 1=Manav, 2=Rakshasa)
  static const List<int> _nakshatraGana = [
    0, 2, 0, 1, 0, 2, 0, 0, 2, 2, 1, 0, 0, 2, 0, 1, 0, 2, 2, 1, 0, 0, 1, 2, 0, 0, 0,
  ];

  // Nakshatra to Nadi (0=Adi/Vata, 1=Madhya/Pitta, 2=Antya/Kapha)
  static const List<int> _nakshatraNadi = [
    0, 0, 0, 1, 1, 1, 2, 2, 2, 0, 0, 0, 1, 1, 1, 2, 2, 2, 0, 0, 0, 1, 1, 1, 2, 2, 2,
  ];

  // Nakshatra lord (for Graha Maitri)
  static const List<String> _nakshatraLords = [
    'Ketu', 'Venus', 'Sun', 'Moon', 'Mars', 'Rahu', 'Jupiter', 'Saturn', 'Mercury',
    'Ketu', 'Venus', 'Sun', 'Moon', 'Mars', 'Rahu', 'Jupiter', 'Saturn', 'Mercury',
    'Ketu', 'Venus', 'Sun', 'Moon', 'Mars', 'Rahu', 'Jupiter', 'Saturn', 'Mercury',
  ];

  // Planet friendship matrix [planet][planet] = 0(neutral), 1(friend), -1(enemy)
  static const Map<String, Map<String, int>> _planetFriendship = {
    'Sun': {'Sun': 0, 'Moon': 1, 'Mars': 1, 'Mercury': -1, 'Jupiter': 1, 'Venus': -1, 'Saturn': -1, 'Rahu': -1, 'Ketu': -1},
    'Moon': {'Sun': 1, 'Moon': 0, 'Mars': 0, 'Mercury': 1, 'Jupiter': 1, 'Venus': 0, 'Saturn': -1, 'Rahu': -1, 'Ketu': -1},
    'Mars': {'Sun': 1, 'Moon': 1, 'Mars': 0, 'Mercury': -1, 'Jupiter': 1, 'Venus': -1, 'Saturn': -1, 'Rahu': -1, 'Ketu': 1},
    'Mercury': {'Sun': 1, 'Moon': -1, 'Mars': -1, 'Mercury': 0, 'Jupiter': -1, 'Venus': 1, 'Saturn': 1, 'Rahu': 1, 'Ketu': -1},
    'Jupiter': {'Sun': 1, 'Moon': 1, 'Mars': 1, 'Mercury': -1, 'Jupiter': 0, 'Venus': -1, 'Saturn': -1, 'Rahu': -1, 'Ketu': 1},
    'Venus': {'Sun': -1, 'Moon': 0, 'Mars': -1, 'Mercury': 1, 'Jupiter': -1, 'Venus': 0, 'Saturn': 1, 'Rahu': 1, 'Ketu': -1},
    'Saturn': {'Sun': -1, 'Moon': -1, 'Mars': -1, 'Mercury': 1, 'Jupiter': -1, 'Venus': 1, 'Saturn': 0, 'Rahu': 1, 'Ketu': -1},
    'Rahu': {'Sun': -1, 'Moon': -1, 'Mars': -1, 'Mercury': 1, 'Jupiter': -1, 'Venus': 1, 'Saturn': 1, 'Rahu': 0, 'Ketu': 0},
    'Ketu': {'Sun': -1, 'Moon': -1, 'Mars': 1, 'Mercury': -1, 'Jupiter': 1, 'Venus': -1, 'Saturn': -1, 'Rahu': 0, 'Ketu': 0},
  };

  static CompatibilityEntity calculate(
    String person1Name,
    int person1Nakshatra,
    int person1Pada,
    String person2Name,
    int person2Nakshatra,
    int person2Pada,
  ) {
    final kootas = <KootaResult>[
      _calculateVarna(person1Nakshatra, person2Nakshatra),
      _calculateVashya(person1Nakshatra, person2Nakshatra),
      _calculateTara(person1Nakshatra, person2Nakshatra),
      _calculateYoni(person1Nakshatra, person2Nakshatra),
      _calculateGrahaMaitri(person1Nakshatra, person2Nakshatra),
      _calculateGana(person1Nakshatra, person2Nakshatra),
      _calculateBhakoot(person1Nakshatra, person2Nakshatra),
      _calculateNadi(person1Nakshatra, person2Nakshatra),
    ];

    return CompatibilityEntity(
      person1Name: person1Name,
      person1Nakshatra: person1Nakshatra,
      person1NakshatraPada: person1Pada,
      person2Name: person2Name,
      person2Nakshatra: person2Nakshatra,
      person2NakshatraPada: person2Pada,
      kootaResults: kootas,
      calculatedAt: DateTime.now(),
    );
  }

  // 1. Varna Koota (1 point) — spiritual/caste compatibility
  static KootaResult _calculateVarna(int n1, int n2) {
    final v1 = _nakshatraVarna[n1 % 27];
    final v2 = _nakshatraVarna[n2 % 27];
    // Groom's varna should be >= bride's varna (or equal)
    final points = (v1 >= v2) ? 1 : 0;
    return KootaResult(
      name: 'Varna',
      maxPoints: 1,
      obtainedPoints: points,
      description: _varnaDesc(v1, v2, points),
      isCompatible: points == 1,
    );
  }

  // 2. Vashya Koota (2 points) — dominance/control
  static KootaResult _calculateVashya(int n1, int n2) {
    final v1 = _nakshatraVashya[n1 % 27];
    final v2 = _nakshatraVashya[n2 % 27];
    int points = 0;
    if (v1 == v2) {
      points = 2;
    } else if (_isVashyaFriend(v1, v2)) {
      points = 1;
    }
    return KootaResult(
      name: 'Vashya',
      maxPoints: 2,
      obtainedPoints: points,
      description: 'Dominance compatibility: $points/2 points.',
      isCompatible: points >= 1,
    );
  }

  // 3. Tara Koota (3 points) — birth star compatibility
  static KootaResult _calculateTara(int n1, int n2) {
    final diff = (n2 - n1 + 27) % 27;
    final taraGroup = (diff % 9) + 1;
    const auspiciousTaras = [1, 3, 5, 7]; // Janma, Kshema, Sadhana, Mitra
    final points = auspiciousTaras.contains(taraGroup) ? 3 : 0;
    return KootaResult(
      name: 'Tara',
      maxPoints: 3,
      obtainedPoints: points,
      description: 'Tara group: $taraGroup — ${points == 3 ? "Auspicious" : "Inauspicious"}.',
      isCompatible: points == 3,
    );
  }

  // 4. Yoni Koota (4 points) — biological/animal compatibility
  static KootaResult _calculateYoni(int n1, int n2) {
    final y1 = _nakshatraYoni[n1 % 27];
    final y2 = _nakshatraYoni[n2 % 27];
    final g1 = _yoniGender[y1 % 15];
    final g2 = _yoniGender[y2 % 15];
    int points;
    if (y1 == y2 && g1 != g2) {
      points = 4; // Same animal, opposite gender = best
    } else if (y1 == y2) {
      points = 3;
    } else if (_isYoniFriendly(y1, y2)) {
      points = 2;
    } else if (_isYoniNeutral(y1, y2)) {
      points = 1;
    } else {
      points = 0;
    }
    return KootaResult(
      name: 'Yoni',
      maxPoints: 4,
      obtainedPoints: points,
      description: 'Animal compatibility: $points/4 points.',
      isCompatible: points >= 2,
    );
  }

  // 5. Graha Maitri (5 points) — moon sign lord friendship
  static KootaResult _calculateGrahaMaitri(int n1, int n2) {
    final lord1 = _nakshatraLords[n1 % 27];
    final lord2 = _nakshatraLords[n2 % 27];
    final f1 = _planetFriendship[lord1]?[lord2] ?? 0;
    final f2 = _planetFriendship[lord2]?[lord1] ?? 0;
    int points;
    if (lord1 == lord2) {
      points = 5;
    } else if (f1 == 1 && f2 == 1) {
      points = 5;
    } else if (f1 == 1 || f2 == 1) {
      points = 4;
    } else if (f1 == 0 && f2 == 0) {
      points = 3;
    } else if (f1 == -1 && f2 == -1) {
      points = 0;
    } else {
      points = 1;
    }
    return KootaResult(
      name: 'Graha Maitri',
      maxPoints: 5,
      obtainedPoints: points,
      description: 'Planetary friendship ($lord1–$lord2): $points/5 points.',
      isCompatible: points >= 3,
    );
  }

  // 6. Gana Koota (6 points) — nature/temperament
  static KootaResult _calculateGana(int n1, int n2) {
    final g1 = _nakshatraGana[n1 % 27];
    final g2 = _nakshatraGana[n2 % 27];
    const ganaNames = ['Deva', 'Manav', 'Rakshasa'];
    int points;
    if (g1 == g2) {
      points = 6;
    } else if ((g1 == 0 && g2 == 1) || (g1 == 1 && g2 == 0)) {
      points = 5; // Deva + Manav
    } else if ((g1 == 1 && g2 == 2) || (g1 == 2 && g2 == 1)) {
      points = 1; // Manav + Rakshasa
    } else {
      points = 0; // Deva + Rakshasa
    }
    return KootaResult(
      name: 'Gana',
      maxPoints: 6,
      obtainedPoints: points,
      description: 'Nature (${ganaNames[g1]} + ${ganaNames[g2]}): $points/6 points.',
      isCompatible: points >= 4,
    );
  }

  // 7. Bhakoot Koota (7 points) — sign compatibility
  static KootaResult _calculateBhakoot(int n1, int n2) {
    final rashi1 = (n1 ~/ 2.25).clamp(0, 11);
    final rashi2 = (n2 ~/ 2.25).clamp(0, 11);
    final diff = ((rashi2 - rashi1) + 12) % 12 + 1;
    // Inauspicious: 2-12, 12-2, 6-8, 8-6, 5-9, 9-5
    const inauspicious = [2, 12, 6, 8, 5, 9];
    final reverseCheck = ((rashi1 - rashi2) + 12) % 12 + 1;
    final points = (inauspicious.contains(diff) && inauspicious.contains(reverseCheck))
        ? 0
        : 7;
    return KootaResult(
      name: 'Bhakoot',
      maxPoints: 7,
      obtainedPoints: points,
      description: 'Sign combination ($diff): $points/7 points.',
      isCompatible: points == 7,
    );
  }

  // 8. Nadi Koota (8 points) — health/constitution
  static KootaResult _calculateNadi(int n1, int n2) {
    final nadi1 = _nakshatraNadi[n1 % 27];
    final nadi2 = _nakshatraNadi[n2 % 27];
    const nadiNames = ['Adi (Vata)', 'Madhya (Pitta)', 'Antya (Kapha)'];
    final points = nadi1 == nadi2 ? 0 : 8;
    return KootaResult(
      name: 'Nadi',
      maxPoints: 8,
      obtainedPoints: points,
      description: 'Health compatibility (${nadiNames[nadi1]} + ${nadiNames[nadi2]}): $points/8 points.',
      isCompatible: points == 8,
    );
  }

  static bool _isVashyaFriend(int v1, int v2) {
    const friendMap = {
      0: [1, 2], 1: [0, 3], 2: [0, 4], 3: [1, 4], 4: [2, 3],
    };
    return friendMap[v1]?.contains(v2) ?? false;
  }

  static bool _isYoniFriendly(int y1, int y2) {
    const friends = {
      0: [5], 1: [8], 2: [13], 3: [10], 4: [7], 5: [0],
      6: [11], 7: [4], 8: [1], 9: [14], 10: [3], 11: [6],
      12: [2], 13: [12], 14: [9],
    };
    return friends[y1]?.contains(y2) ?? false;
  }

  static bool _isYoniNeutral(int y1, int y2) {
    final diff = (y1 - y2).abs();
    return diff != 0 && diff != 1;
  }

  static String _varnaDesc(int v1, int v2, int points) {
    const names = ['Brahmin', 'Kshatriya', 'Vaishya', 'Shudra'];
    return '${names[v1 % 4]} + ${names[v2 % 4]}: $points/1 point.';
  }
}
