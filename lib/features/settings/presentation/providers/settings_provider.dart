import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/constants/app_constants.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en', 'US');
  bool _dailyHoroscopeNotification = true;
  bool _auspiciousTimingNotification = false;
  bool _festivalReminders = true;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get dailyHoroscopeNotification => _dailyHoroscopeNotification;
  bool get auspiciousTimingNotification => _auspiciousTimingNotification;
  bool get festivalReminders => _festivalReminders;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final themeStr = prefs.getString(AppConstants.keyThemeMode) ?? 'system';
      _themeMode = switch (themeStr) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

      final langCode = prefs.getString(AppConstants.keyLanguage) ?? 'en';
      _locale = langCode == 'hi' ? const Locale('hi', 'IN') : const Locale('en', 'US');

      _dailyHoroscopeNotification =
          prefs.getBool('daily_horoscope_notif') ?? true;
      _auspiciousTimingNotification =
          prefs.getBool('auspicious_timing_notif') ?? false;
      _festivalReminders = prefs.getBool('festival_reminders') ?? true;

      notifyListeners();
    } catch (e) {
      debugPrint('Load settings error: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeStr = switch (mode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        _ => 'system',
      };
      await prefs.setString(AppConstants.keyThemeMode, modeStr);
    } catch (e) {
      debugPrint('Set theme error: $e');
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyLanguage, locale.languageCode);
    } catch (e) {
      debugPrint('Set locale error: $e');
    }
  }

  Future<void> setDailyHoroscopeNotification(bool value) async {
    _dailyHoroscopeNotification = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_horoscope_notif', value);
  }

  Future<void> setAuspiciousTimingNotification(bool value) async {
    _auspiciousTimingNotification = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auspicious_timing_notif', value);
  }

  Future<void> setFestivalReminders(bool value) async {
    _festivalReminders = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('festival_reminders', value);
  }
}
