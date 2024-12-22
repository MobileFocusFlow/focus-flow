import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
      },
    );

    await requestPermissions();
    FirebaseMessaging.onMessage.listen(_handleFirebaseMessage);
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      if (int.parse(Platform.version.split('.')[0]) >= 33) {
        await _checkPostNotificationsPermission();
      }
    } else if (Platform.isIOS) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  Future<void> _checkPostNotificationsPermission() async {
    if (await Permission.notification.isGranted) {
    } else {
      await Permission.notification.request();

      if (await Permission.notification.isGranted) {
      } else {
        await openAppSettings();
      }
    }
  }

  Future<void> sendInstantNotification(String title, String content) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_channel_id',
        'Instant Notifications',
        channelDescription: 'This channel is for instant notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      0,
      title,
      content,
      notificationDetails,
    );
  }

  Future<void> sendScheduledNotification(
      String title, String content, DateTime scheduledTime) async {
    final tz.TZDateTime tzScheduledTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    if (tzScheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'scheduled_channel_id',
        'Scheduled Notifications',
        channelDescription: 'This channel is for scheduled notifications',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.zonedSchedule(
      0,
      title,
      content,
      tzScheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.inexact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void _handleFirebaseMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      sendInstantNotification(
          notification.title ?? 'Title', notification.body ?? 'Body');
    }
  }
}
