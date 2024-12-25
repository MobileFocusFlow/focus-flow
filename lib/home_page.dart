import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:focusflow/components/language_select.dart';
import 'main.dart';
import 'routine_screen.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  void _updateLanguage(String language) {
    setState(() {
      TextsInApp.setSelectedLanguage(language);
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ThemeNotifier.themeNotifier.value == ThemeMode.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.grey.shade500, Colors.black12]
                : [Colors.orangeAccent, Colors.pinkAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ValueListenableBuilder<double>(
          valueListenable: FontSizeNotifier.fontSizeNotifier,
          builder: (context, fontSize, child) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title with Animation
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      TextsInApp.getText(
                          "home_page_welcome"), //'Welcome to the Routine App',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Routine Screen Button
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RoutineScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange.shade600,
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 40),
                        textStyle: TextStyle(fontSize: fontSize),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.list, size: 24, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                              TextsInApp.getText(
                                  "home_page_goto_routine_screen"),
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Settings Screen Button
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(
                              updateLanguageCallback: _updateLanguage,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings, size: 24),
                      label: Text(
                        TextsInApp.getText("home_page_settings"),
                        style:
                            TextStyle(color: Colors.white, fontSize: fontSize),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange.shade600,
                        padding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
