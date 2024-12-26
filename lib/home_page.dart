import 'package:flutter/material.dart';
import 'package:focusflow/components/language_select.dart';
import 'package:focusflow/guideline.dart';
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orangeAccent, Colors.pinkAccent],
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
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.orange.withOpacity(0.34),
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      "lib/assets/images/logo.png",
                      height: 190,
                      width: 190,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    TextsInApp.getText("home_page_welcome"),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoutineScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 118, 192, 65),
                      padding: const EdgeInsets.symmetric(
                          vertical: 23, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      TextsInApp.getText("home_page_goto_routine_screen"),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GuidelineScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.menu_book, size: 26),
                    iconAlignment: IconAlignment.start,
                    label: Text(
                      TextsInApp.getText("home_page_guideline"), //"Guideline"
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 118, 192, 65),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(
                              updateLanguageCallback: _updateLanguage),
                        ),
                      );
                    },
                    iconAlignment: IconAlignment.start,
                    icon: const Icon(Icons.settings, size: 26),
                    label: Text(
                      TextsInApp.getText("home_page_settings"),
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 118, 192, 65),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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
