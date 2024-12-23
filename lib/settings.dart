import 'package:flutter/material.dart';
import 'package:focusflow/components/language_select.dart';
import 'main.dart';

class SettingsScreen extends StatefulWidget {
  final Function(String) updateLanguageCallback;

  const SettingsScreen({super.key, required this.updateLanguageCallback});
  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = ThemeNotifier.themeNotifier.value == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.updateLanguageCallback(TextsInApp.getSelectedLanguage());
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Dark Mode Option
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
                  setState(() {
                    isDarkMode = value;
                    ThemeNotifier.themeNotifier.value =
                        value ? ThemeMode.dark : ThemeMode.light;
                  });
                },
              ),
            ),
            const Divider(),
            // Language Option
            LanguageSelectionWidget(),
            const Divider(),

            // Font Size Option
            ValueListenableBuilder<double>(
              valueListenable: FontSizeNotifier.fontSizeNotifier,
              builder: (context, fontSize, child) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  leading: const Icon(Icons.text_fields,
                      color: Colors.deepPurpleAccent),
                  title: const Text(
                    'Font Size',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  subtitle: Text(
                    'Current: ${fontSize.toInt()}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  trailing: IconButton(
                    icon:
                        const Icon(Icons.edit, color: Colors.deepPurpleAccent),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          double tempFontSize = fontSize;
                          return StatefulBuilder(
                            builder: (context, setDialogState) {
                              return AlertDialog(
                                alignment: Alignment.center,
                                title: const Text('Adjust Font Size'),
                                content: SizedBox(
                                  width: 300,
                                  height: 120,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Slider(
                                        value: tempFontSize,
                                        min: 10.0,
                                        max: 20.0,
                                        divisions: 10,
                                        label: tempFontSize.toInt().toString(),
                                        onChanged: (value) {
                                          setDialogState(() {
                                            tempFontSize = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      FontSizeNotifier.fontSizeNotifier.value =
                                          tempFontSize;
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
