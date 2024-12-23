import 'package:flutter/material.dart';
import 'package:focusflow/calendar.dart';
import 'package:focusflow/eat_that_frog.dart';
import 'package:focusflow/eisenhower_matrix_screen.dart';
import 'package:focusflow/home_page.dart';
import 'package:focusflow/login.dart';
import 'components/language_select.dart';
import 'main.dart';
import 'task_batching_screen.dart';
import 'routine_creation_form.dart';
import 'routine_list.dart';
import 'temp_user_db.dart';

class Routine {
  static IconData getTechniqueIcon(String technique) {
    if (technique == Routine.pomodoroIdentifier) {
      return Routine.pomodoroIcon;
    } else if (technique == Routine.timeBlockingIdentifier) {
      return Routine.timeBlockingIcon;
    } else if (technique == Routine.zenIdentifier) {
      return Routine.zenIcon;
    } else if (technique == Routine.eatThatFrogIdentifier) {
      return Routine.eatThatFrogIcon;
    } else {
      return Icons.task_alt;
    }
  }

  static Color getTechniqueColor(String technique, bool isDarkMode) {
    if (technique == pomodoroIdentifier) {
      return isDarkMode ? Colors.red.shade300 : Colors.red.shade600;
    } else if (technique == timeBlockingIdentifier) {
      return isDarkMode ? Colors.teal.shade300 : Colors.teal.shade600;
    } else if (technique == zenIdentifier) {
      return isDarkMode ? Colors.green.shade300 : Colors.green.shade600;
    } else if (technique == taskBatchingIdentifier) {
      return isDarkMode
          ? Colors.deepPurpleAccent.shade200
          : Colors.deepPurpleAccent.shade400;
    } else if (technique == eisenhowerIdentifier) {
      return isDarkMode ? Colors.lightBlue.shade300 : Colors.lightBlue.shade600;
    } else if (technique == eatThatFrogIdentifier) {
      return isDarkMode
          ? Colors.deepOrange.shade300
          : Colors.deepOrange.shade600;
    }
    return Colors.black;
  }

  static IconData zenIcon = Icons.self_improvement;
  static IconData pomodoroIcon = Icons.timer;
  static IconData timeBlockingIcon = Icons.schedule;
  static IconData eatThatFrogIcon = Icons.priority_high;
  static IconData taskBatchingIcon = Icons.assignment;
  static IconData eisenhowerIcon = Icons.dataset_outlined;

  static String pomodoroIdentifier = "Pomodoro";
  static String timeBlockingIdentifier = "Time Blocking";
  static String zenIdentifier = "Zen";
  static String eatThatFrogIdentifier = "Eat That Frog";
  static String taskBatchingIdentifier = "Task Batching";
  static String eisenhowerIdentifier = "Eisenhower";

  String key;
  String title;
  DateTime dateTime;
  String workingTechnique;
  int workDuration;
  int breakDuration;
  int routineCount;
  String postItNote;
  int priority;

  Routine(
    this.key,
    this.title,
    this.dateTime,
    this.workingTechnique,
    this.workDuration,
    this.breakDuration,
    this.routineCount,
    this.postItNote,
    this.priority,
  );
}

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  RoutineScreenState createState() => RoutineScreenState();
}

class RoutineScreenState extends State<RoutineScreen> {
  void _addRoutine(
      String key,
      String title,
      DateTime dateTime,
      String workingTechnique,
      int workingDuration,
      int? breakDuration,
      int routineCount,
      String postItNote,
      int priority) {
    final routine = Routine(
      key,
      title,
      dateTime,
      workingTechnique,
      workingDuration,
      workingTechnique == Routine.pomodoroIdentifier ? (breakDuration ?? 0) : 5,
      routineCount,
      postItNote,
      priority,
    );

    setState(() {
      UserDatabase.getRoutines().add(routine);
    });
  }

  void _updateRoutine(Routine updatedRoutine) {
    setState(() {
      final index = UserDatabase.getRoutines().indexWhere((routine) =>
          routine.title == updatedRoutine.title &&
          routine.dateTime == updatedRoutine.dateTime);
      if (index != -1) {
        UserDatabase.getRoutines()[index] = updatedRoutine;
      }
    });
  }

  void _navigateToTaskBatchingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskBatchingScreen(),
      ),
    );
  }

  void _navigateToEatThatFrogScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EatThatFrogScreen(
          onRoutineUpdated: _updateRoutine,
        ),
      ),
    );
  }

  void _navigateToEisenhowerScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EisenhowerMatrixScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TextsInApp.getText("routine_screen_my_routines"), //"My Routines",
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [Colors.black, Colors.black45, Colors.black]
                  : [
                      Colors.deepOrangeAccent,
                      Colors.deepOrangeAccent.shade200,
                      Colors.deepOrangeAccent
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Switch(
            value: isDarkMode,
            activeColor: Colors.white,
            onChanged: (value) {
              setState(() {
                ThemeNotifier.themeNotifier.value =
                    value ? ThemeMode.dark : ThemeMode.light;
              });
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ValueListenableBuilder<double>(
        valueListenable: FontSizeNotifier.fontSizeNotifier,
        builder: (context, fontSize, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.black38, Colors.grey.shade900, Colors.black38]
                    : [Colors.white, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      TextsInApp.getText(
                          "routine_screen_working_techniques"), //"Working Techniques",
                      style: TextStyle(
                        fontSize: fontSize + 10,
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode ? Colors.white : Colors.deepOrangeAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _buildTechniqueCards(isDarkMode, fontSize),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      TextsInApp.getText(
                          "routine_screen_task_handling"), //"Task Handling",
                      style: TextStyle(
                        fontSize: fontSize + 10,
                        fontWeight: FontWeight.bold,
                        color:
                            isDarkMode ? Colors.white : Colors.deepOrangeAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _buildTaskHandlingCards(isDarkMode, fontSize),
                  const SizedBox(height: 16),
                  Expanded(
                    child: RoutineList(
                      onRoutineUpdated: _updateRoutine,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: isDarkMode ? Colors.black : Colors.deepOrangeAccent,
        height: 70,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarIcon(
                context,
                Icons.home,
                TextsInApp.getText("routine_screen_home") /*"Home"*/,
                const HomePage(),
                isDarkMode),
            _buildNavBarIcon(
                context,
                Icons.calendar_month_outlined,
                TextsInApp.getText("routine_screen_calendar") /*"Calendar"*/,
                const CalendarScreen(),
                isDarkMode),
            _buildNavBarIcon(
                context,
                Icons.notifications,
                TextsInApp.getText("routine_screen_alerts") /*"Alerts"*/,
                null,
                isDarkMode),
            _buildNavBarIcon(
                context,
                Icons.person,
                TextsInApp.getText("routine_screen_profile") /*"Profile"*/,
                const LoginScreen(),
                isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarIcon(BuildContext context, IconData icon, String label,
      Widget? screen, bool isDarkMode) {
    return GestureDetector(
      onTap: screen != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              );
            }
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 25),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey.shade300 : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskHandlingCards(bool isDarkMode, double fontSize) {
    return Wrap(
      spacing: 15.0,
      runSpacing: 14.0,
      children: [
        _buildTechniqueCard(
          Routine.taskBatchingIdentifier,
          Routine.taskBatchingIcon,
          Routine.getTechniqueColor(Routine.taskBatchingIdentifier, isDarkMode),
          fontSize,
        ),
        _buildTechniqueCard(
          Routine.eisenhowerIdentifier,
          Routine.eisenhowerIcon,
          Routine.getTechniqueColor(Routine.eisenhowerIdentifier, isDarkMode),
          fontSize,
        ),
        _buildTechniqueCard(
          Routine.eatThatFrogIdentifier,
          Routine.eatThatFrogIcon,
          Routine.getTechniqueColor(Routine.eatThatFrogIdentifier, isDarkMode),
          fontSize,
        ),
      ],
    );
  }

  Widget _buildTechniqueCards(bool isDarkMode, double fontSize) {
    return Wrap(
      spacing: 15.0,
      runSpacing: 14.0,
      children: [
        _buildTechniqueCard(
          Routine.zenIdentifier,
          Routine.zenIcon,
          Routine.getTechniqueColor(Routine.zenIdentifier, isDarkMode),
          fontSize,
        ),
        _buildTechniqueCard(
          Routine.pomodoroIdentifier,
          Routine.pomodoroIcon,
          Routine.getTechniqueColor(Routine.pomodoroIdentifier, isDarkMode),
          fontSize,
        ),
        _buildTechniqueCard(
          Routine.timeBlockingIdentifier,
          Routine.timeBlockingIcon,
          Routine.getTechniqueColor(Routine.timeBlockingIdentifier, isDarkMode),
          fontSize,
        ),
      ],
    );
  }

  Widget _buildTechniqueCard(
      String technique, IconData icon, Color cardColor, double fontSize) {
    return GestureDetector(
      onTap: () {
        if (technique == Routine.taskBatchingIdentifier) {
          _navigateToTaskBatchingScreen();
        } else if (technique == Routine.eisenhowerIdentifier) {
          _navigateToEisenhowerScreen();
        } else if (technique == Routine.eatThatFrogIdentifier) {
          _navigateToEatThatFrogScreen();
        } else {
          _showNewRoutineDialog(technique);
        }
      },
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: cardColor,
        child: Container(
          height: 150,
          width: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(1, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 35),
              const SizedBox(height: 8),
              Text(
                technique,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize + 2,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNewRoutineDialog(String technique) {
    showDialog(
      context: context,
      builder: (context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Dialog(
          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<double>(
                  valueListenable: FontSizeNotifier.fontSizeNotifier,
                  builder: (context, fontSize, child) {
                    return Text(
                      "${TextsInApp.getText("routine_screen_create_routine_for")}$technique" /*"Create a Routine for "*/,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                RoutineCreationForm(
                  workingTechnique: technique,
                  onRoutineCreated: _addRoutine,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
