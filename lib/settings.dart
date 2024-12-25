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

  void _updateLanguage(String language) {
    setState(() {
      TextsInApp.setSelectedLanguage(language);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextsInApp.getText("routine_screen_settings")), //'Settings'
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
              title: Text(
                TextsInApp.getText("dark_mode"), //'Dark Mode'
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
            LanguageSelectionWidget(
              onLanguageUpdated: _updateLanguage,
            ),
            const Divider(),

            // Font Size Option
            ValueListenableBuilder<double>(
              valueListenable: FontSizeNotifier.fontSizeNotifier,
              builder: (context, fontSize, child) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  leading: const Icon(Icons.text_fields,
                      color: Colors.deepPurpleAccent),
                  title: Text(
                    TextsInApp.getText("font_size"), //'Font Size'
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  subtitle: Text(
                    "${TextsInApp.getText("current")}: ${fontSize.toInt()}",
                    style: TextStyle(fontSize: 15.0),
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
                                title: Text(TextsInApp.getText(
                                    "settings_adjust_font_size")),
                                content: SizedBox(
                                  width: 300,
                                  height: 120,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Slider(
                                        value: tempFontSize,
                                        min: 9.0,
                                        max: 19.0,
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
                                    child: Text(TextsInApp.getText(
                                        "cancel")), //'Cancel'
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      FontSizeNotifier.fontSizeNotifier.value =
                                          tempFontSize;
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                        TextsInApp.getText("save")), //'Save'
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
