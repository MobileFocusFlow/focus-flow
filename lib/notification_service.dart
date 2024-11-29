import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:html' as html;
import 'dart:async';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void scheduleNotification(String title, DateTime scheduledTime) {
    final localTime = tz.TZDateTime.local(
      scheduledTime.year,
      scheduledTime.month,
      scheduledTime.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

    _flutterLocalNotificationsPlugin.zonedSchedule(
      scheduledTime.hashCode,
      'Routine Reminder',
      'It\'s time for: $title',
      localTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'routine_channel',
          'Routines',
          channelDescription: 'Notifications for scheduled routines',
        ),
      ),
      // ignore: deprecated_member_use
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

void showWebNotification(String title, String body, DateTime scheduledTime) {
  final now = DateTime.now();
  final delay = scheduledTime.difference(now).inMilliseconds;

  if (delay > 0) {
    Timer(Duration(milliseconds: delay), () {
      html.Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          html.Notification(title, body: body);
        } else {
          debugPrint('Permission denied for notifications.');
        }
      });
    });
  } else {
    // If the time has already passed, show immediately
    html.Notification.requestPermission().then((permission) {
      if (permission == 'granted') {
        html.Notification(title, body: body);
      } else {
        debugPrint('Permission denied for notifications.');
      }
    });
  }
}
