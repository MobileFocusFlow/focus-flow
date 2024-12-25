import 'package:flutter/material.dart';
import 'package:focusflow/components/language_dict.dart';
import '../routine_screen.dart';
import '../temp_user_db.dart';

class TextsInApp {
  static String getTechniqueNameWithLanguage(String technique) {
    String languageCode = getLanguageCode();

    if (technique == Routine.pomodoroIdentifier) {
      return "Pomodoro";
    } else if (technique == Routine.timeBlockingIdentifier) {
      if (languageCode == "en") {
        return "Time Blocking";
      } else if (languageCode == "tr") {
        return "Zaman Bloklama";
      } else if (languageCode == "fr") {
        return "Bloc de Temps";
      } else if (languageCode == "de") {
        return "Zeitblockierung";
      } else {
        return Routine.timeBlockingIdentifier;
      }
    } else if (technique == Routine.zenIdentifier) {
      if (languageCode == "en") {
        return "Zen";
      } else if (languageCode == "tr") {
        return "Sükunet";
      } else if (languageCode == "fr") {
        return "Zen";
      } else if (languageCode == "de") {
        return "Zen";
      } else {
        return Routine.zenIdentifier;
      }
    } else if (technique == Routine.taskBatchingIdentifier) {
      if (languageCode == "en") {
        return "Task Batching";
      } else if (languageCode == "tr") {
        return "Görev Gruplama";
      } else if (languageCode == "fr") {
        return "Regroupement des Tâches";
      } else if (languageCode == "de") {
        return "Aufgabenbündelung";
      } else {
        return Routine.taskBatchingIdentifier;
      }
    } else if (technique == Routine.eisenhowerIdentifier) {
      if (languageCode == "en") {
        return "Eisenhower Matrix";
      } else if (languageCode == "tr") {
        return "Eisenhower Matrisi";
      } else if (languageCode == "fr") {
        return "Matrice Eisenhower";
      } else if (languageCode == "de") {
        return "Eisenhower-Matrix";
      } else {
        return Routine.eisenhowerIdentifier;
      }
    } else if (technique == Routine.eatThatFrogIdentifier) {
      if (languageCode == "en") {
        return "Eat That Frog";
      } else if (languageCode == "tr") {
        return "Ye O Kurbağayı";
      } else if (languageCode == "fr") {
        return "Mange cette Grenouille";
      } else if (languageCode == "de") {
        return "Iss den Frosch";
      } else {
        return Routine.eatThatFrogIdentifier;
      }
    } else {
      return technique;
    }
  }

  static String getSelectedLanguage() {
    return UserDatabase
            .userPrefs[UserDatabase.activeEmail]?.selectedLanguauge ??
        'English';
  }

  static void setSelectedLanguage(String language) {
    UserDatabase.userPrefs[UserDatabase.activeEmail]?.selectedLanguauge =
        language;
  }

  static String getText(String key) {
    String languageCode = getLanguageCode();
    return LanguageDictionary.texts[languageCode]?[key] ?? key;
  }

  static String getLanguageCode() {
    switch (getSelectedLanguage()) {
      case 'English':
        return 'en';
      case 'Türkçe':
        return 'tr';
      case 'French':
        return 'fr';
      case 'German':
        return 'de';
      case 'Spanish':
        return 'es';
      default:
        return 'en';
    }
  }
}

class LanguageSelectionWidget extends StatefulWidget {
  final Function(String) onLanguageUpdated;
  const LanguageSelectionWidget({super.key, required this.onLanguageUpdated});

  @override
  // ignore: library_private_types_in_public_api
  _LanguageSelectionWidgetState createState() =>
      _LanguageSelectionWidgetState();
}

class _LanguageSelectionWidgetState extends State<LanguageSelectionWidget> {
  final List<String> _languages = [
    'English',
    'Türkçe',
    'French',
    'German',
    'Spanish'
  ];
  String _selectedLanguage = 'English';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  _loadLanguage() {
    setState(() {
      _selectedLanguage =
          UserDatabase.userPrefs[UserDatabase.activeEmail]?.selectedLanguauge ??
              'English';
    });
  }

  _saveLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
      UserDatabase.userPrefs[UserDatabase.activeEmail]!.selectedLanguauge =
          language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "${TextsInApp.getText("select_language")}:", //'Select Language:'
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      trailing: DropdownButton<String>(
        value: _selectedLanguage,
        onChanged: (String? newLanguage) {
          if (newLanguage != null) {
            _saveLanguage(newLanguage);
            widget.onLanguageUpdated(newLanguage);
          }
        },
        items: _languages.map<DropdownMenuItem<String>>((String language) {
          return DropdownMenuItem<String>(
            value: language,
            child: Text(language),
          );
        }).toList(),
      ),
    );
  }
}
