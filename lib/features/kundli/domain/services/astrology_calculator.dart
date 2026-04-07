import 'dart:math' as math;
import '../entities/birth_details_entity.dart';
import '../entities/kundli_entity.dart';
import '../../../../config/constants/app_constants.dart';

/// Vedic Astrology Calculator using standard astronomical algorithms.
/// Calculates planetary positions using mean longitude approximations
/// calibrated for the sidereal zodiac (Lahiri ayanamsa).
class AstrologyCalculator {
  static const double _deg2rad = math.pi / 180.0;
  static const double _rad2deg = 180.0 / math.pi;

  // Lahiri Ayanamsa base (1900 Jan 0.5)
  static const double _ayanamsaBase = 22.460148;
  static const double _ayanamsaRate = 50.2388475 / 3600.0; // degrees per year

  /// Calculate Julian Day Number
  static double julianDayNumber(int year, int month, int day, double hour) {
    int y = year;
    int m = month;
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        day +
        hour / 24.0 +
        b -
        1524.5;
  }

  /// Julian centuries from J2000.0
  static double julianCenturies(double jd) {
    return (jd - 2451545.0) / 36525.0;
  }

  /// Calculate Lahiri Ayanamsa for given JD
  static double lahiriAyanamsa(double jd) {
    final t = julianCenturies(jd);
    // Approximate Lahiri ayanamsa
    return 23.85 + t * 50.2388 / 3600.0;
  }

  /// Normalize angle to 0–360
  static double normalizeAngle(double angle) {
    angle = angle % 360;
    if (angle < 0) angle += 360;
    return angle;
  }

  /// Get Rashi (zodiac sign) index 0-11 from longitude
  static int getRashi(double longitude) {
    return (longitude / 30).floor() % 12;
  }

  /// Get degree within Rashi 0-30
  static double getRashiDegree(double longitude) {
    return longitude % 30;
  }

  /// Get Nakshatra index 0-26 from sidereal longitude
  static int getNakshatra(double longitude) {
    return (longitude * 27 / 360).floor() % 27;
  }

  /// Get Nakshatra Pada 1-4
  static int getNakshatraPada(double longitude) {
    final totalPadas = longitude * 108 / 360;
    return (totalPadas % 4).floor() + 1;
  }

  /// Calculate Greenwich Mean Sidereal Time in degrees
  static double gmst(double jd) {
    final t = julianCenturies(jd);
    double gmst0 =
        100.4606184 + 36000.77004 * t + 0.000387933 * t * t - t * t * t / 38710000.0;
    return normalizeAngle(gmst0);
  }

  /// Calculate Local Sidereal Time in degrees
  static double localSiderealTime(double jd, double longitude) {
    return normalizeAngle(gmst(jd) + longitude);
  }

  /// Calculate Ascendant (Lagna) longitude
  static double calculateAscendant(double jd, double latitude, double longitude) {
    final lst = localSiderealTime(jd, longitude) * _deg2rad;
    final lat = latitude * _deg2rad;
    // Obliquity of ecliptic
    final t = julianCenturies(jd);
    final eps = (23.439291111 - 0.013004167 * t - 0.0000001639 * t * t) * _deg2rad;

    // Calculate ascendant
    final x = -math.cos(lst);
    final y = math.sin(lst) * math.cos(eps) + math.tan(lat) * math.sin(eps);
    double asc = math.atan2(x, y) * _rad2deg;
    if (asc < 0) asc += 360;
    return asc;
  }

  // ---------- Planetary Mean Longitude Calculations ----------

  static double _sunLongitude(double t) {
    // Sun's mean longitude
    final L0 = 280.46646 + 36000.76983 * t;
    final M = (357.52911 + 35999.05029 * t) * _deg2rad;
    final C = (1.914602 - 0.004817 * t) * math.sin(M) +
        0.019993 * math.sin(2 * M) +
        0.000289 * math.sin(3 * M);
    return normalizeAngle(L0 + C);
  }

  static double _moonLongitude(double t) {
    // Moon's mean longitude (simplified)
    final L = 218.3165 + 481267.8813 * t;
    final M = (134.9634 + 477198.8676 * t) * _deg2rad;
    final Mprime = (357.5291 + 35999.0503 * t) * _deg2rad;
    final D = (297.8502 + 445267.1115 * t) * _deg2rad;
    final F = (93.2720 + 483202.0175 * t) * _deg2rad;
    final correction = 6.2888 * math.sin(M) +
        1.2740 * math.sin(2 * D - M) +
        0.6583 * math.sin(2 * D) +
        0.2136 * math.sin(2 * M) +
        -0.1851 * math.sin(Mprime) +
        -0.1144 * math.sin(2 * F);
    return normalizeAngle(L + correction);
  }

  static double _marsLongitude(double t) {
    final L = 355.433 + 19140.2993 * t;
    final M = (19.3730 + 19140.2993 * t) * _deg2rad;
    final C = 10.6912 * math.sin(M) + 0.6228 * math.sin(2 * M);
    return normalizeAngle(L + C);
  }

  static double _mercuryLongitude(double t) {
    final L = 252.2508 + 149472.6746 * t;
    final M = (174.7948 + 149472.5153 * t) * _deg2rad;
    final C = 23.4400 * math.sin(M) + 2.9818 * math.sin(2 * M);
    return normalizeAngle(L + C);
  }

  static double _jupiterLongitude(double t) {
    final L = 34.3515 + 3034.9057 * t;
    final M = (20.9 + 3034.6748 * t) * _deg2rad;
    final C = 5.5549 * math.sin(M) + 0.1683 * math.sin(2 * M);
    return normalizeAngle(L + C);
  }

  static double _venusLongitude(double t) {
    final L = 181.9798 + 58517.8156 * t;
    final M = (212.2794 + 58517.8039 * t) * _deg2rad;
    final C = 0.7758 * math.sin(M) + 0.0033 * math.sin(2 * M);
    return normalizeAngle(L + C);
  }

  static double _saturnLongitude(double t) {
    final L = 50.0774 + 1222.1138 * t;
    final M = (317.0207 + 1221.5515 * t) * _deg2rad;
    final C = 6.3585 * math.sin(M) + 0.2204 * math.sin(2 * M);
    return normalizeAngle(L + C);
  }

  static double _rahuLongitude(double t) {
    // Mean lunar node (Rahu) - retrograde
    final node = 125.0445 - 1934.1363 * t;
    return normalizeAngle(node);
  }

  static double _ketuLongitude(double t) {
    // Ketu is opposite to Rahu
    return normalizeAngle(_rahuLongitude(t) + 180);
  }

  /// Apply ayanamsa to get sidereal longitude
  static double toSidereal(double tropicalLongitude, double ayanamsa) {
    return normalizeAngle(tropicalLongitude - ayanamsa);
  }

  /// Calculate house cusp longitudes using Equal House system
  static List<double> calculateHouseCusps(double ascendant) {
    return List.generate(12, (i) => normalizeAngle(ascendant + i * 30));
  }

  /// Determine which house a planet falls in
  static int getPlanetHouse(double planetLong, double ascendant) {
    final diff = normalizeAngle(planetLong - ascendant);
    return (diff / 30).floor() + 1;
  }

  /// Check if planet is exalted
  static bool isExalted(String planet, int rashi) {
    const exaltations = {
      'Sun': 0, // Aries
      'Moon': 1, // Taurus
      'Mars': 9, // Capricorn
      'Mercury': 5, // Virgo
      'Jupiter': 3, // Cancer
      'Venus': 11, // Pisces
      'Saturn': 6, // Libra
      'Rahu': 1, // Taurus (some traditions)
      'Ketu': 7, // Scorpio (some traditions)
    };
    return exaltations[planet] == rashi;
  }

  /// Check if planet is debilitated
  static bool isDebilitated(String planet, int rashi) {
    const debilitations = {
      'Sun': 6, // Libra
      'Moon': 7, // Scorpio
      'Mars': 3, // Cancer
      'Mercury': 11, // Pisces
      'Jupiter': 9, // Capricorn
      'Venus': 5, // Virgo
      'Saturn': 0, // Aries
      'Rahu': 7, // Scorpio
      'Ketu': 1, // Taurus
    };
    return debilitations[planet] == rashi;
  }

  /// Check if planet is combust (within certain degrees of Sun)
  static bool isCombust(String planet, double planetLong, double sunLong) {
    const combustDegrees = {
      'Moon': 12.0,
      'Mars': 17.0,
      'Mercury': 14.0,
      'Jupiter': 11.0,
      'Venus': 10.0,
      'Saturn': 15.0,
    };
    if (!combustDegrees.containsKey(planet)) return false;
    double diff = (planetLong - sunLong).abs();
    if (diff > 180) diff = 360 - diff;
    return diff < combustDegrees[planet]!;
  }

  /// Calculate Vimshottari Dasha
  static List<DashaPeriod> calculateVimshottariDasha(
    int moonNakshatra,
    DateTime birthDate,
    double moonLongitudeSidereal,
  ) {
    // Dasha sequence starting from nakshatra lord
    const dashaYears = [7, 20, 6, 10, 7, 18, 16, 19, 17]; // Total = 120
    const dashaLords = [
      'Ketu', 'Venus', 'Sun', 'Moon', 'Mars', 'Rahu', 'Jupiter', 'Saturn', 'Mercury'
    ];
    // Nakshatra lord mapping (each lord rules 3 nakshatras in order)
    const nakshatraLords = [
      'Ketu', 'Venus', 'Sun', 'Moon', 'Mars', 'Rahu', 'Jupiter', 'Saturn', 'Mercury',
      'Ketu', 'Venus', 'Sun', 'Moon', 'Mars', 'Rahu', 'Jupiter', 'Saturn', 'Mercury',
      'Ketu', 'Venus', 'Sun', 'Moon', 'Mars', 'Rahu', 'Jupiter', 'Saturn', 'Mercury',
    ];

    final nakshatraLord = nakshatraLords[moonNakshatra];
    final startDashaIndex = dashaLords.indexOf(nakshatraLord);

    // Calculate elapsed portion of first dasha
    final nakshatraStart = moonNakshatra * (360.0 / 27);
    final nakshatraEnd = nakshatraStart + (360.0 / 27);
    final moonPosInNakshatra = moonLongitudeSidereal - nakshatraStart;
    final nakshatraSize = nakshatraEnd - nakshatraStart;
    final elapsedFraction = moonPosInNakshatra / nakshatraSize;
    final firstDashaYears = dashaYears[startDashaIndex];
    final elapsedYears = elapsedFraction * firstDashaYears;
    final remainingFirstDasha = firstDashaYears - elapsedYears;

    final dashas = <DashaPeriod>[];
    DateTime currentDate = birthDate;

    for (int i = 0; i < 9; i++) {
      final idx = (startDashaIndex + i) % 9;
      final lord = dashaLords[idx];
      final years = i == 0 ? remainingFirstDasha : dashaYears[idx].toDouble();
      final days = (years * 365.25).round();
      final endDate = currentDate.add(Duration(days: days));

      final antarDashas = _calculateAntarDasha(lord, currentDate, endDate);
      dashas.add(DashaPeriod(
        planet: lord,
        startDate: currentDate,
        endDate: endDate,
        years: dashaYears[idx],
        antarDashas: antarDashas,
      ));
      currentDate = endDate;
    }

    return dashas;
  }

  static List<DashaPeriod> _calculateAntarDasha(
    String mahaLord,
    DateTime start,
    DateTime end,
  ) {
    const dashaYears = [7, 20, 6, 10, 7, 18, 16, 19, 17];
    const dashaLords = [
      'Ketu', 'Venus', 'Sun', 'Moon', 'Mars', 'Rahu', 'Jupiter', 'Saturn', 'Mercury'
    ];
    const totalYears = 120;

    final mahaIdx = dashaLords.indexOf(mahaLord);
    final mahaYears = dashaYears[mahaIdx];
    final totalDays = end.difference(start).inDays;

    final antarDashas = <DashaPeriod>[];
    DateTime current = start;

    for (int i = 0; i < 9; i++) {
      final idx = (mahaIdx + i) % 9;
      final lord = dashaLords[idx];
      final antarYears = dashaYears[idx];
      final days = (totalDays * antarYears / (totalYears)).round();
      final endDate = current.add(Duration(days: days));
      antarDashas.add(DashaPeriod(
        planet: lord,
        startDate: current,
        endDate: endDate,
        years: antarYears,
      ));
      current = endDate;
    }
    return antarDashas;
  }

  /// Detect major yogas in the chart
  static List<KundliYoga> detectYogas(
    List<PlanetPosition> planets,
    int lagnaRashi,
  ) {
    final yogas = <KundliYoga>[];
    final planetMap = {for (var p in planets) p.planet: p};

    // Gaja Kesari Yoga: Jupiter in kendra from Moon
    final moon = planetMap['Moon'];
    final jupiter = planetMap['Jupiter'];
    if (moon != null && jupiter != null) {
      final diff = (jupiter.house - moon.house).abs();
      final isKendra = diff == 0 || diff == 3 || diff == 6 || diff == 9;
      yogas.add(KundliYoga(
        name: 'Gaja Kesari Yoga',
        description:
            'Jupiter in a Kendra from Moon gives wisdom, prosperity and fame.',
        isPresent: isKendra,
        involvedPlanets: ['Jupiter', 'Moon'],
      ));
    }

    // Raj Yoga: Lord of Kendra conjunct/aspect lord of Trikona
    final sun = planetMap['Sun'];
    if (sun != null && moon != null && jupiter != null) {
      final isSunMoonKendra = _isKendra((sun.house - lagnaRashi).abs() % 12 + 1);
      yogas.add(KundliYoga(
        name: 'Raj Yoga',
        description: 'Planetary combinations bestowing royal status and authority.',
        isPresent: isSunMoonKendra,
        involvedPlanets: ['Sun', 'Moon', 'Jupiter'],
      ));
    }

    // Budha Aditya Yoga: Sun and Mercury in same house
    final mercury = planetMap['Mercury'];
    if (sun != null && mercury != null) {
      yogas.add(KundliYoga(
        name: 'Budha Aditya Yoga',
        description:
            'Sun and Mercury together gives intelligence and communication skills.',
        isPresent: sun.house == mercury.house,
        involvedPlanets: ['Sun', 'Mercury'],
      ));
    }

    // Shasha Yoga: Saturn in own sign or exalted in Kendra
    final saturn = planetMap['Saturn'];
    if (saturn != null) {
      final isSaturnStrong = (saturn.rashi == 9 || saturn.rashi == 10) &&
          _isKendra(saturn.house);
      yogas.add(KundliYoga(
        name: 'Shasha Yoga',
        description: 'Saturn strong in Kendra gives discipline, longevity and power.',
        isPresent: isSaturnStrong,
        involvedPlanets: ['Saturn'],
      ));
    }

    // Hamsa Yoga: Jupiter in own sign or exalted in Kendra
    if (jupiter != null) {
      final isJupiterStrong = (jupiter.rashi == 8 || jupiter.rashi == 11 || jupiter.rashi == 3) &&
          _isKendra(jupiter.house);
      yogas.add(KundliYoga(
        name: 'Hamsa Yoga',
        description: 'Jupiter strong in Kendra bestows wisdom, spirituality and prosperity.',
        isPresent: isJupiterStrong,
        involvedPlanets: ['Jupiter'],
      ));
    }

    // Malavya Yoga: Venus in own sign or exalted in Kendra
    final venus = planetMap['Venus'];
    if (venus != null) {
      final isVenusStrong = (venus.rashi == 1 || venus.rashi == 6 || venus.rashi == 11) &&
          _isKendra(venus.house);
      yogas.add(KundliYoga(
        name: 'Malavya Yoga',
        description: 'Venus strong in Kendra grants beauty, luxury and artistic talent.',
        isPresent: isVenusStrong,
        involvedPlanets: ['Venus'],
      ));
    }

    // Chandra Mangala Yoga: Moon and Mars conjunction
    final mars = planetMap['Mars'];
    if (moon != null && mars != null) {
      yogas.add(KundliYoga(
        name: 'Chandra Mangala Yoga',
        description: 'Moon and Mars together indicates financial acumen and courage.',
        isPresent: moon.house == mars.house,
        involvedPlanets: ['Moon', 'Mars'],
      ));
    }

    // Kemadruma Yoga: No planets in 2nd or 12th from Moon (considered inauspicious)
    if (moon != null) {
      final housesBesidemoon = planets
          .where((p) => p.planet != 'Moon' && p.planet != 'Rahu' && p.planet != 'Ketu')
          .map((p) => p.house);
      final adj1 = ((moon.house - 2) % 12) + 1;
      final adj2 = (moon.house % 12) + 1;
      final noAdjacent = !housesBesidemoon.contains(adj1) &&
          !housesBesidemoon.contains(adj2);
      yogas.add(KundliYoga(
        name: 'Kemadruma Yoga',
        description: 'No planets adjacent to Moon can create instability in life.',
        isPresent: noAdjacent,
        involvedPlanets: ['Moon'],
      ));
    }

    return yogas;
  }

  static bool _isKendra(int house) {
    return house == 1 || house == 4 || house == 7 || house == 10;
  }

  /// Main function: calculate complete kundli
  static KundliEntity calculateKundli(
    String id,
    BirthDetailsEntity birth,
  ) {
    final jd = julianDayNumber(
      birth.birthYear,
      birth.birthMonth,
      birth.birthDay,
      birth.timeOfBirthHour - birth.timezone,
    );
    final t = julianCenturies(jd);
    final ayanamsa = lahiriAyanamsa(jd);

    // Calculate tropical longitudes
    final sunTropical = _sunLongitude(t);
    final moonTropical = _moonLongitude(t);
    final marsTropical = _marsLongitude(t);
    final mercuryTropical = _mercuryLongitude(t);
    final jupiterTropical = _jupiterLongitude(t);
    final venusTropical = _venusLongitude(t);
    final saturnTropical = _saturnLongitude(t);
    final rahuTropical = _rahuLongitude(t);
    final ketuTropical = _ketuLongitude(t);

    // Convert to sidereal
    final sunSid = toSidereal(sunTropical, ayanamsa);
    final moonSid = toSidereal(moonTropical, ayanamsa);
    final marsSid = toSidereal(marsTropical, ayanamsa);
    final mercurySid = toSidereal(mercuryTropical, ayanamsa);
    final jupiterSid = toSidereal(jupiterTropical, ayanamsa);
    final venusSid = toSidereal(venusTropical, ayanamsa);
    final saturnSid = toSidereal(saturnTropical, ayanamsa);
    final rahuSid = toSidereal(rahuTropical, ayanamsa);
    final ketuSid = toSidereal(ketuTropical, ayanamsa);

    // Calculate ascendant
    final ascTropical = calculateAscendant(jd, birth.latitude, birth.longitude);
    final ascSid = toSidereal(ascTropical, ayanamsa);
    final lagnaRashi = getRashi(ascSid);

    // Build planet positions
    final planetData = [
      ('Sun', sunSid, false),
      ('Moon', moonSid, false),
      ('Mars', marsSid, false),
      ('Mercury', mercurySid, false),
      ('Jupiter', jupiterSid, false),
      ('Venus', venusSid, false),
      ('Saturn', saturnSid, true), // Rough retrograde check
      ('Rahu', rahuSid, true), // Rahu always retrograde
      ('Ketu', ketuSid, true), // Ketu always retrograde
    ];

    final planetPositions = planetData.map((pd) {
      final name = pd.$1;
      final longitude = pd.$2;
      final retro = pd.$3;
      final rashi = getRashi(longitude);
      final house = getPlanetHouse(longitude, ascSid);
      return PlanetPosition(
        planet: name,
        longitude: longitude,
        rashi: rashi,
        rashiDegree: getRashiDegree(longitude),
        nakshatra: getNakshatra(longitude),
        nakshatraPada: getNakshatraPada(longitude),
        house: house,
        isRetrograde: retro,
        isCombust: name != 'Sun' ? isCombust(name, longitude, sunSid) : false,
        isExalted: isExalted(name, rashi),
        isDebilitated: isDebilitated(name, rashi),
      );
    }).toList();

    // House rashis
    final houseRashis = List.generate(
      12,
      (i) => (lagnaRashi + i) % 12,
    );

    // Vimshottari Dasha
    final moonNakshatra = getNakshatra(moonSid);
    final dashas = calculateVimshottariDasha(
      moonNakshatra,
      birth.dateOfBirth,
      moonSid,
    );

    // Detect yogas
    final yogas = detectYogas(planetPositions, lagnaRashi);

    return KundliEntity(
      id: id,
      birthDetails: birth,
      lagnaRashi: lagnaRashi,
      lagnaLongitude: ascSid,
      planetPositions: planetPositions,
      houseRashis: houseRashis,
      dashas: dashas,
      yogas: yogas,
      createdAt: DateTime.now(),
    );
  }
}
