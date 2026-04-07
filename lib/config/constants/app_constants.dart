import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primarySaffron = Color(0xFFFF6B00);
  static const Color primaryGold = Color(0xFFFFD700);
  static const Color deepPurple = Color(0xFF1A0533);
  static const Color darkBg = Color(0xFF0D0221);
  static const Color accentGreen = Color(0xFF00C853);
  static const Color accentRed = Color(0xFFD32F2F);

  // Dimensions
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 350);
  static const Duration animationSlow = Duration(milliseconds: 600);
  static const Duration splashDuration = Duration(seconds: 3);

  // SharedPreferences keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyLocale = 'locale';
  static const String keyNotifications = 'notifications_enabled';
  static const String keyDailyHoroscope = 'daily_horoscope_enabled';
  static const String keyKundliList = 'kundli_list';
  static const String keyProfileList = 'profile_list';
  static const String keyUserData = 'user_data';
  static const String keyIsLoggedIn = 'is_logged_in';

  // API
  static const String baseApiUrl = 'https://api.kundliapp.example.com/v1';

  // Zodiac Signs
  static const List<String> zodiacSigns = [
    'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
    'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
  ];

  static const List<String> zodiacSignsHindi = [
    'मेष', 'वृषभ', 'मिथुन', 'कर्क', 'सिंह', 'कन्या',
    'तुला', 'वृश्चिक', 'धनु', 'मकर', 'कुम्भ', 'मीन',
  ];

  static const List<String> zodiacSymbols = [
    '♈', '♉', '♊', '♋', '♌', '♍',
    '♎', '♏', '♐', '♑', '♒', '♓',
  ];

  // Nakshatras (27 + 1 Abhijit)
  static const List<String> nakshatras = [
    'Ashwini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashira', 'Ardra',
    'Punarvasu', 'Pushya', 'Ashlesha', 'Magha', 'Purva Phalguni',
    'Uttara Phalguni', 'Hasta', 'Chitra', 'Swati', 'Vishakha', 'Anuradha',
    'Jyeshtha', 'Moola', 'Purva Ashadha', 'Uttara Ashadha', 'Shravana',
    'Dhanishtha', 'Shatabhisha', 'Purva Bhadrapada', 'Uttara Bhadrapada',
    'Revati',
  ];

  static const List<String> nakshatrasHindi = [
    'अश्विनी', 'भरणी', 'कृत्तिका', 'रोहिणी', 'मृगशिरा', 'आर्द्रा',
    'पुनर्वसु', 'पुष्य', 'आश्लेषा', 'मघा', 'पूर्वाफाल्गुनी',
    'उत्तराफाल्गुनी', 'हस्त', 'चित्रा', 'स्वाति', 'विशाखा', 'अनुराधा',
    'ज्येष्ठा', 'मूल', 'पूर्वाषाढ़', 'उत्तराषाढ़', 'श्रवण',
    'धनिष्ठा', 'शतभिषा', 'पूर्वाभाद्रपद', 'उत्तराभाद्रपद',
    'रेवती',
  ];

  // Planets
  static const List<String> planets = [
    'Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus',
    'Saturn', 'Rahu', 'Ketu',
  ];

  static const List<String> planetsHindi = [
    'सूर्य', 'चंद्र', 'मंगल', 'बुध', 'गुरु', 'शुक्र',
    'शनि', 'राहु', 'केतु',
  ];

  static const List<String> planetSymbols = [
    '☉', '☽', '♂', '☿', '♃', '♀', '♄', '☊', '☋',
  ];

  // Dasha years
  static const List<int> dashaYears = [7, 20, 6, 10, 7, 18, 16, 19, 17];
  static const List<String> dashaOrder = [
    'Ketu', 'Venus', 'Sun', 'Moon', 'Mars', 'Rahu', 'Jupiter', 'Saturn', 'Mercury'
  ];

  // Houses
  static const List<String> houses = [
    'Lagna (Ascendant)', 'Dhana (Wealth)', 'Sahaja (Siblings)', 'Sukha (Happiness)',
    'Putra (Children)', 'Ripu (Enemies)', 'Kalatra (Spouse)', 'Mrityu (Death)',
    'Bhagya (Fortune)', 'Karma (Career)', 'Labha (Gains)', 'Vyaya (Expenditure)',
  ];

  // Weekdays
  static const List<String> weekdays = [
    'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
  ];

  // Gemstones for planets
  static const Map<String, String> planetGemstones = {
    'Sun': 'Ruby (Manik)',
    'Moon': 'Pearl (Moti)',
    'Mars': 'Red Coral (Moonga)',
    'Mercury': 'Emerald (Panna)',
    'Jupiter': 'Yellow Sapphire (Pukhraj)',
    'Venus': 'Diamond (Heera)',
    'Saturn': 'Blue Sapphire (Neelam)',
    'Rahu': 'Hessonite (Gomed)',
    'Ketu': "Cat's Eye (Lehsunia)",
  };

  // Colors for planets
  static const Map<String, Color> planetColors = {
    'Sun': Color(0xFFFF8F00),
    'Moon': Color(0xFFE0E0E0),
    'Mars': Color(0xFFD32F2F),
    'Mercury': Color(0xFF388E3C),
    'Jupiter': Color(0xFFFFD700),
    'Venus': Color(0xFFEC407A),
    'Saturn': Color(0xFF455A64),
    'Rahu': Color(0xFF6A1B9A),
    'Ketu': Color(0xFF4E342E),
  };

  // Zodiac gradients
  static const List<List<Color>> zodiacGradients = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E53)], // Aries
    [Color(0xFF4CAF50), Color(0xFF8BC34A)], // Taurus
    [Color(0xFF26C6DA), Color(0xFF00BCD4)], // Gemini
    [Color(0xFF7986CB), Color(0xFF5C6BC0)], // Cancer
    [Color(0xFFFFD700), Color(0xFFFF8F00)], // Leo
    [Color(0xFF66BB6A), Color(0xFF43A047)], // Virgo
    [Color(0xFFEC407A), Color(0xFFE91E63)], // Libra
    [Color(0xFFEF5350), Color(0xFFB71C1C)], // Scorpio
    [Color(0xFFFF7043), Color(0xFFE64A19)], // Sagittarius
    [Color(0xFF78909C), Color(0xFF546E7A)], // Capricorn
    [Color(0xFF29B6F6), Color(0xFF0288D1)], // Aquarius
    [Color(0xFF7E57C2), Color(0xFF512DA8)], // Pisces
  ];

  // Remedy categories
  static const List<String> remedyCategories = [
    'Career', 'Health', 'Marriage', 'Finance', 'Education', 'Family', 'Spiritual',
  ];

  // App version
  static const String appVersion = '1.0.0';
  static const String appName = 'Kundli App';
  static const String supportEmail = 'support@kundliapp.com';
  static const String privacyPolicyUrl = 'https://kundliapp.com/privacy';
  static const String termsUrl = 'https://kundliapp.com/terms';

  // Premium
  static const String premiumMonthlyId = 'kundli_premium_monthly';
  static const String premiumYearlyId = 'kundli_premium_yearly';
  static const double premiumMonthlyPrice = 99.0;
  static const double premiumYearlyPrice = 799.0;

  // Color aliases for compatibility
  static const Color darkBackground = darkBg;
  static const Color cardDark = Color(0xFF1E0A3C);
  static const Color cardDark2 = Color(0xFF2A0F4A);
  static const String keyLanguage = keyLocale;
}
