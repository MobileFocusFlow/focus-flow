import 'package:flutter/material.dart';
import 'package:focusflow/zen_screen.dart';
import '../pomodoro_screen.dart';
import '../time_blocking_screen.dart';
import '../routine_screen.dart';
import 'language_select.dart';

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
