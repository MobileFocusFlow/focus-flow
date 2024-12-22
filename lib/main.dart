import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'api/firebase_api.dart';
import 'notification_service.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();

  final firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications();

  runApp(const MyApp());
}

class ThemeNotifier {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeNotifier.themeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              brightness: Brightness.dark,
              seedColor: Colors.deepPurple,
            ),
          ),
          themeMode: themeMode,
          home: const LoginScreen(),
        );
      },
    );
  }
}
