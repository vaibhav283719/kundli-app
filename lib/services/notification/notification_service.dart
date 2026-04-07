import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../main.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String _dailyHoroscopeChannelId = 'daily_horoscope';
  static const String _reminderChannelId = 'reminders';
  static const String _generalChannelId = 'general';

  Future<void> requestPermissions() async {
    try {
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
    } catch (e) {
      debugPrint('Permission request error: $e');
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String channelId = _generalChannelId,
    String channelName = 'General',
  }) async {
    try {
      final androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: 'General notifications from Kundli App',
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: const Color(0xFFFF6B00),
        playSound: true,
        enableVibration: true,
      );
      final details = NotificationDetails(android: androidDetails);
      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        details,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Show notification error: $e');
    }
  }

  Future<void> scheduleDailyHoroscope({
    required String zodiacSign,
    required int hour,
    required int minute,
  }) async {
    try {
      await cancelNotification(0);
      debugPrint(
        'Daily horoscope scheduled for $zodiacSign at $hour:${minute.toString().padLeft(2, '0')}',
      );
    } catch (e) {
      debugPrint('Schedule notification error: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } catch (e) {
      debugPrint('Cancel notification error: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
    } catch (e) {
      debugPrint('Cancel all notifications error: $e');
    }
  }

  Future<void> showDailyHoroscopeNotification(
    String zodiacSign,
    String prediction,
  ) async {
    await showNotification(
      id: 1,
      title: '🌟 Today\'s $zodiacSign Horoscope',
      body: prediction,
      channelId: _dailyHoroscopeChannelId,
      channelName: 'Daily Horoscope',
    );
  }

  Future<void> showAuspiciousTimingReminder(
    String event,
    String timing,
  ) async {
    await showNotification(
      id: 2,
      title: '🕐 Auspicious Timing Reminder',
      body: '$event starts at $timing',
      channelId: _reminderChannelId,
      channelName: 'Reminders',
    );
  }
}
