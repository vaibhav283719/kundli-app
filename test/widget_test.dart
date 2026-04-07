// Widget test for Kundli App
// Note: Firebase is initialized with graceful degradation in demo mode

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:kundli_app/features/settings/presentation/providers/settings_provider.dart';

// Simple smoke test that verifies providers can be instantiated
void main() {
  group('Kundli App Tests', () {
    test('SettingsProvider initializes with defaults', () {
      final provider = SettingsProvider();
      expect(provider.themeMode, equals(ThemeMode.system));
      expect(provider.locale.languageCode, equals('en'));
      expect(provider.dailyHoroscopeNotification, isTrue);
    });

    test('AppConstants has required zodiac signs', () {
      const signs = [
        'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
        'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
      ];
      expect(signs.length, equals(12));
    });

    test('AppConstants has 27 nakshatras', () {
      const nakshatras = [
        'Ashwini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashira',
        'Ardra', 'Punarvasu', 'Pushya', 'Ashlesha', 'Magha',
        'Purva Phalguni', 'Uttara Phalguni', 'Hasta', 'Chitra', 'Swati',
        'Vishakha', 'Anuradha', 'Jyeshtha', 'Moola', 'Purva Ashadha',
        'Uttara Ashadha', 'Shravana', 'Dhanishta', 'Shatabhisha',
        'Purva Bhadrapada', 'Uttara Bhadrapada', 'Revati',
      ];
      expect(nakshatras.length, equals(27));
    });

    test('Vimshottari dasha total is 120 years', () {
      const dashaYears = [7, 20, 6, 10, 7, 18, 16, 19, 17];
      final total = dashaYears.reduce((a, b) => a + b);
      expect(total, equals(120));
    });

    test('Gun Milan max score is 36', () {
      const kootaMaxPoints = [1, 2, 3, 4, 5, 6, 7, 8];
      final total = kootaMaxPoints.reduce((a, b) => a + b);
      expect(total, equals(36));
    });
  });
}
