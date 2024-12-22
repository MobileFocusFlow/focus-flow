// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:focusflow/notification_service.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // Request notification permissions
    await _firebaseMessaging.requestPermission();

    // Get the device FCM token
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        NotificationService().sendInstantNotification(
          notification.title ?? 'Title',
          notification.body ?? 'Body',
        );
      }
    });

    // Handle background and terminated state messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Process when user taps on a notification
      print('Notification opened: ${message.notification?.title}');
    });

    // Subscribe to a topic (optional, for topic-based notifications)
    await _firebaseMessaging.subscribeToTopic('all_users');
  }
}
