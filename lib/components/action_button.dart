import 'package:flutter/material.dart';
import 'package:focusflow/zen_screen.dart';
import '../pomodoro.dart';
import '../time_blocking_screen.dart';
import '../routine_screen.dart';

class ActionButton extends StatelessWidget {
  final Routine routine;

  const ActionButton({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton.icon(
        onPressed: () {
          _handleActionButton(context);
        },
        style: _elevatedButtonStyle(),
        icon: iconTechnique(),
        label: labelTechnique(),
      ),
    );
  }

  Icon iconTechnique() {
    Icon selectedIcon = const Icon(Icons.block);

    if (routine.workingTechnique == "Pomodoro") {
      selectedIcon = const Icon(Icons.timer);
    } else if (routine.workingTechnique == "Time Blocking") {
      selectedIcon = const Icon(Icons.calendar_today);
    } else if (routine.workingTechnique == "Zen") {
      selectedIcon = const Icon(Icons.self_improvement);
    }

    return selectedIcon;
  }

  Text labelTechnique() {
    String labelContent = "Unsupported Tecnique";
    if (routine.workingTechnique == "Pomodoro") {
      labelContent = "Start Pomodoro Session";
    } else if (routine.workingTechnique == "Time Blocking") {
      labelContent = "Start Time Blocking";
    } else if (routine.workingTechnique == "Zen") {
      labelContent = "Start Zen Mode";
    }

    return Text(labelContent,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600));
  }

  void _handleActionButton(BuildContext context) {
    if (routine.workingTechnique == "Pomodoro") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PomodoroScreen(
            taskName: routine.title,
            workDuration: routine.workDuration * 60,
            breakDuration: routine.breakDuration * 60,
          ),
        ),
      );
    } else if (routine.workingTechnique == "Time Blocking") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TimeBlockingScreen(
            taskName: routine.title,
            blockDuration: routine.blockDuration * 60,
          ),
        ),
      );
    } else if (routine.workingTechnique == "Zen") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ZenScreen(
            taskName: routine.title,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${routine.workingTechnique} is not supported yet."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  ButtonStyle _elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.deepOrangeAccent,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
    );
  }
}
