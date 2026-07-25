import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Riverpod Provider for the Notification Service
final notificationProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  // Singleton pattern matching your DatabaseService
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Bootstraps the notification system. Called in main.dart.
  static Future<void> init() async {
    try {
      // 1. Initialize Timezones (Required for scheduling routines)
      tz.initializeTimeZones();
      // Note: In a full production app, you'd use flutter_timezone to get the actual local timezone.
      // For V1, setting a default local timezone prevents crashes.
      tz.setLocalLocation(tz.getLocation('UTC')); 

      // 2. Android Configuration
      // 'ic_launcher' must exist in android/app/src/main/res/drawable
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // 3. iOS Configuration
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // 4. Initialize Plugin
      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          log('Notification Tapped: ${response.payload}', name: 'NotificationService');
          // In the future: use GoRouter to navigate to a specific Task or Routine based on payload
        },
      );

      // 5. Request Android 13+ Permissions explicitly
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      log('Notification System Online', name: 'NotificationService');
    } catch (e, stack) {
      log('Notification System Failure', error: e, stackTrace: stack, name: 'NotificationService');
    }
  }

  /// Channel configuration enforcing your premium monochrome brand
  NotificationDetails _getChannelDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'steps_mission_control_channel',
        'Mission Control Alerts',
        channelDescription: 'High priority system directives and routine reminders.',
        importance: Importance.max,
        priority: Priority.high,
        color: Color(0xFF000000), // Strict Black styling
        enableLights: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  /// Fires an immediate notification (e.g., "Super Streak Unlocked!")
  Future<void> showImmediate({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _notificationsPlugin.show(
      id,
      title,
      body,
      _getChannelDetails(),
      payload: payload,
    );
  }

  /// Schedules a daily recurring notification (e.g., "Wake up routine at 6:00 AM")
  Future<void> scheduleDailyRoutine({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      _getChannelDetails(),
      matchDateTimeComponents: DateTimeComponents.time, // Repeats daily at this exact time
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    log('Routine Scheduled: $hour:$minute', name: 'NotificationService');
  }

  /// Cancels a specific directive
  Future<void> cancel(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// Clears all pending directives
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}