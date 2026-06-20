import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'user_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _preferenceKey = 'streak_reminder_enabled';

  // Initialize notifications
  static Future<void> initialize() async {
    debugPrint("🔔 [DEBUG notifications] Iniciando initialize()...");
    tz.initializeTimeZones();
    try {
      final String timeZoneName = (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
      debugPrint("🔔 [DEBUG notifications] Timezone definido: $timeZoneName");
    } catch (e) {
      debugPrint("🔔 [DEBUG notifications] Erro ao obter fuso horário: $e");
      try {
        tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));
      } catch (_) {
        tz.setLocalLocation(tz.UTC);
      }
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Handle notification click if needed
      },
    );
    debugPrint("🔔 [DEBUG notifications] Plugin inicializado");

    // Initial scheduling based on active preferences (default: false/disabled)
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_preferenceKey) ?? false;
    debugPrint("🔔 [DEBUG notifications] Lembrete ativo: $enabled");
    if (enabled) {
      await scheduleDailyStreakReminder();
    }
  }

  // Request runtime permission (needed for iOS and Android 13+)
  static Future<bool> requestPermission() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Android
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      final granted = await androidImplementation.requestNotificationsPermission();
      if (granted == true) {
        await prefs.setBool(_preferenceKey, true);
        await scheduleDailyStreakReminder();
        return true;
      }
      return false;
    }

    // iOS
    final iosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      if (granted == true) {
        await prefs.setBool(_preferenceKey, true);
        await scheduleDailyStreakReminder();
        return true;
      }
      return false;
    }

    return false;
  }

  // Helper to mark a practice as completed and update the streak
  static Future<void> markPracticeCompleted() async {
    await UserService.updateStreak();
  }

  // Schedule daily notifications for 20:00 (8 PM)
  static Future<void> scheduleDailyStreakReminder() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_preferenceKey) ?? false;
    if (!enabled) return;

    await cancelAllReminders();

    final user = UserService.currentUser;
    // Only schedule if user has a custom profile (not the default "Estudante")
    if (!UserService.hasCustomProfile) return;

    // Format check for today's date
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final studiedToday = user.lastStudyDate == todayStr;

    // Schedule for 8:00 PM today or tomorrow depending on practice
    var scheduleTime = DateTime(now.year, now.month, now.day, 20, 0);

    if (studiedToday || now.isAfter(scheduleTime)) {
      // If user already studied today, or it's past 8 PM today, schedule for tomorrow 8 PM
      scheduleTime = scheduleTime.add(const Duration(days: 1));
    }

    final streak = user.streak;
    final title = streak > 0 ? "🔥 ¡No pierdas tu racha de $streak dias!" : "📚 ¡Hora de practicar Español!";
    const body = "¡Completa una lección hoy para mantener tu racha activa y no perder tu progreso!";

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'streak_reminder_channel',
      'Lembrete de Ofensiva',
      channelDescription: 'Notificações diárias para evitar perder o streak de estudo',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      final tzScheduleTime = tz.TZDateTime.from(scheduleTime, tz.local);
      await _notificationsPlugin.zonedSchedule(
        888, // Constant ID for the daily reminder
        title,
        body,
        tzScheduleTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint("Streak reminder scheduled successfully for $scheduleTime");
    } catch (e) {
      debugPrint("Error scheduling streak reminder: $e");
    }
  }

  // Cancel reminder
  static Future<void> cancelAllReminders() async {
    await _notificationsPlugin.cancel(888);
    debugPrint("Streak reminders cancelled successfully");
  }

  // Update preferences state
  static Future<void> updateReminderState(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_preferenceKey, enabled);
    if (enabled) {
      await scheduleDailyStreakReminder();
    } else {
      await cancelAllReminders();
    }
  }

  // Get active state
  static Future<bool> isReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_preferenceKey) ?? false;
  }
}
