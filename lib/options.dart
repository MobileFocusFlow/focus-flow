import 'package:flutter/material.dart';
import 'main.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeNotifier.themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Options'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              leading:
                  const Icon(Icons.dark_mode, color: Colors.deepPurpleAccent),
              title: const Text(
                'Dark Mode',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  ThemeNotifier.themeNotifier.value =
                      value ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
