import 'package:flutter/material.dart';
import 'package:focusflow/zen_screen.dart';
import '../calendar.dart';
import '../home_page.dart';
import '../login.dart';
import '../pomodoro_screen.dart';
import '../settings.dart';
import '../time_blocking_screen.dart';
import '../routine_screen.dart';
import 'language_select.dart';

class AppDecorations {
  static AppBar getTechniqueAppBar(
      String title, bool isDarkMode, String workingTechnique) {
    String identifier = "";
    if (workingTechnique.toLowerCase().contains("pomodoro")) {
      identifier = Routine.pomodoroIdentifier;
    } else if (workingTechnique.toLowerCase().contains("zen")) {
      identifier = Routine.zenIdentifier;
    } else if (workingTechnique.toLowerCase().contains("time blocking")) {
      identifier = Routine.timeBlockingIdentifier;
    } else if (workingTechnique.toLowerCase().contains("task batching")) {
      identifier = Routine.taskBatchingIdentifier;
    } else if (workingTechnique.toLowerCase().contains("eisenhower")) {
      identifier = Routine.eisenhowerIdentifier;
    } else if (workingTechnique.toLowerCase().contains("eat that frog")) {
      identifier = Routine.eatThatFrogIdentifier;
    }
    return AppBar(
        title: Text(
          "${TextsInApp.getTechniqueNameWithLanguage(identifier)}: $title",
          style: TextStyle(fontSize: 22),
        ),
        backgroundColor: Routine.getTechniqueColor(identifier, isDarkMode),
        centerTitle: true,
        elevation: 4);
  }

  static ElevatedButton getStartButtonForTimer(bool isRunning, startTimer) {
    return ElevatedButton.icon(
      onPressed: isRunning ? null : startTimer,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
      ),
      icon: const Icon(Icons.play_arrow, size: 25),
      label: Text(TextsInApp.getText("start"), style: TextStyle(fontSize: 15)),
    );
  }

  static ElevatedButton getPauseButtonForTimer(bool isRunning, pauseTimer) {
    return ElevatedButton.icon(
      onPressed: isRunning ? pauseTimer : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
      ),
      icon: const Icon(Icons.pause, size: 25),
      label: Text(TextsInApp.getText("pause"), style: TextStyle(fontSize: 15)),
    );
  }

  static ElevatedButton getResetButtonForTimer(resetTimer) {
    return ElevatedButton.icon(
      onPressed: resetTimer,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
      ),
      icon: const Icon(Icons.replay, size: 25),
      label: Text(TextsInApp.getText("reset"), style: TextStyle(fontSize: 15)),
    );
  }

  static BottomAppBar getAppBottomBar(
      buildNavBarIcon, isDarkMode, context, updateLanguage, updateRoutine) {
    return BottomAppBar(
      color: isDarkMode ? Colors.black : Colors.deepOrangeAccent,
      height: 70,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavBarIcon(
              context,
              Icons.home,
              TextsInApp.getText("routine_screen_home") /*"Home"*/,
              const HomePage(),
              isDarkMode),
          buildNavBarIcon(
              context,
              Icons.calendar_month_outlined,
              TextsInApp.getText("routine_screen_calendar") /*"Calendar"*/,
              CalendarScreen(
                onRoutineUpdated: updateRoutine,
              ),
              isDarkMode),
          buildNavBarIcon(
              context,
              Icons.settings,
              TextsInApp.getText("routine_screen_settings") /*"Settings"*/,
              SettingsScreen(updateLanguageCallback: updateLanguage),
              isDarkMode),
          buildNavBarIcon(
              context,
              Icons.person,
              TextsInApp.getText("routine_screen_profile") /*"Profile"*/,
              const LoginScreen(),
              isDarkMode),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final Routine routine;
  final double fontSize;
  final bool isDarkMode;

  const ActionButton(
      {super.key,
      required this.routine,
      required this.fontSize,
      required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton.icon(
        onPressed: () {
          _handleActionButton(routine, context);
        },
        style: _elevatedButtonStyle(),
        icon: iconTechnique(),
        label: labelTechnique(),
      ),
    );
  }

  Icon iconTechnique() {
    Icon selectedIcon = const Icon(Icons.block);

    if (routine.workingTechnique == Routine.pomodoroIdentifier) {
      selectedIcon = const Icon(Icons.timer);
    } else if (routine.workingTechnique == Routine.timeBlockingIdentifier) {
      selectedIcon = const Icon(Icons.calendar_today);
    } else if (routine.workingTechnique == Routine.zenIdentifier) {
      selectedIcon = const Icon(Icons.self_improvement);
    }

    return selectedIcon;
  }

  Text labelTechnique() {
    String labelContent = TextsInApp.getText(
        "action_button_unsuported_technique") /*"Unsupported Tecnique"*/;
    if (routine.workingTechnique == Routine.pomodoroIdentifier) {
      labelContent = TextsInApp.getText(
          "action_button_start_pomodoro") /*"Start Pomodoro Session"*/;
    } else if (routine.workingTechnique == Routine.timeBlockingIdentifier) {
      labelContent = TextsInApp.getText(
          "action_button_start_time_b") /*"Start Time Blocking"*/;
    } else if (routine.workingTechnique == Routine.zenIdentifier) {
      labelContent =
          TextsInApp.getText("action_button_start_zen") /*"Start Zen Mode"*/;
    }

    return Text(" $labelContent ",
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600));
  }

  void _handleActionButton(Routine routine, BuildContext context) {
    navigateToScene(routine, context);
  }

  static void navigateToScene(Routine routine, BuildContext context) {
    if (routine.workingTechnique == Routine.pomodoroIdentifier) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PomodoroScreen(
            selectedRoutine: routine,
          ),
        ),
      );
    } else if (routine.workingTechnique == Routine.timeBlockingIdentifier) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TimeBlockingScreen(
            selectedRoutine: routine,
          ),
        ),
      );
    } else if (routine.workingTechnique == Routine.zenIdentifier) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ZenScreen(
            selectedRoutine: routine,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${routine.workingTechnique} ${TextsInApp.getText("action_button_isnt_supported")}",
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  ButtonStyle _elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor:
          Routine.getTechniqueColor(routine.workingTechnique, isDarkMode),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
    );
  }
}
