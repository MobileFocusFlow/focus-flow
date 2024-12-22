// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'notification_service.dart';
import 'api/firebase_api.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  TestScreenState createState() => TestScreenState();
}

class TestScreenState extends State<TestScreen> {
  final FirebaseApi _firebaseApi = FirebaseApi();

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _firebaseApi.initNotifications();
    print("Firebase and Notification services initialized.");
  }

  Future<void> _sendTestNotification() async {
    NotificationService().sendInstantNotification(
      "Test Notification",
      "This is a test notification. Everything works fine!",
    );
  }

  Future<void> _sendScheduledNotification() async {
    final DateTime scheduledTime =
        DateTime.now().add(const Duration(seconds: 10));
    NotificationService().sendScheduledNotification(
      "Scheduled Notification",
      "This notification is scheduled 10 seconds from now.",
      scheduledTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Screen"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _sendTestNotification,
              child: const Text("Send Instant Notification"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendScheduledNotification,
              child: const Text("Send Scheduled Notification"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _firebaseApi.initNotifications();
              },
              child: const Text("Reinitialize Firebase Notifications"),
            ),
          ],
        ),
      ),
    );
  }
}
