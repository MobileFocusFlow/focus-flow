import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'task_batching_screen.dart';
import 'routine_creation_form.dart';
import 'routine_list.dart';

class Routine {
  String title;
  DateTime dateTime;
  String workingTechnique;
  int workDuration;
  int breakDuration;
  int blockDuration;

  Routine(
    this.title,
    this.dateTime,
    this.workingTechnique,
    this.workDuration,
    this.breakDuration,
    this.blockDuration,
  );

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'dateTime': dateTime.toIso8601String(),
      'workingTechnique': workingTechnique,
      'workDuration': workDuration,
      'breakDuration': breakDuration,
      'blockDuration': blockDuration,
    };
  }
}

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  RoutineScreenState createState() => RoutineScreenState();
}

class RoutineScreenState extends State<RoutineScreen> {
  final List<Routine> _routines = [];

  Future<void> _addRoutine(String title, DateTime dateTime,
      String workingTechnique, int duration, int? breakDuration) async {
    final userId =
        "example_user"; // Burayı Firebase Authentication ile dinamik yapabilirsiniz
    final routine = Routine(
      title,
      dateTime,
      workingTechnique,
      workingTechnique == "Pomodoro" ? duration : 25,
      workingTechnique == "Pomodoro" ? (breakDuration ?? 0) : 5,
      workingTechnique == "Time Blocking" ? duration : 60,
    );

    // Firestore'a ekleme
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('routines')
        .add(routine.toMap());

    // State'e ekleme
    setState(() {
      _routines.add(routine);
    });

    print("Rutin Firestore'a eklendi ve state güncellendi.");
  }

  void _updateRoutine(Routine updatedRoutine) {
    setState(() {
      final index = _routines.indexWhere((routine) =>
          routine.title == updatedRoutine.title &&
          routine.dateTime == updatedRoutine.dateTime);
      if (index != -1) {
        _routines[index] = updatedRoutine;
      }
    });
  }

  void _navigateToTaskBatchingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TaskBatchingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Routines"),
        backgroundColor:
            isDarkMode ? Colors.grey[900] : Colors.deepOrangeAccent,
        centerTitle: true,
        elevation: 4,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Choose a Working Technique",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildTechniqueCards(isDarkMode),
            const SizedBox(height: 16),
            Expanded(
              child: RoutineList(
                routines: _routines,
                onRoutineUpdated: _updateRoutine,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechniqueCards(bool isDarkMode) {
    return Wrap(
      spacing: 18.0,
      runSpacing: 16.0,
      children: [
        _buildTechniqueCard("Zen", Icons.self_improvement,
            isDarkMode ? Colors.deepPurple : Colors.purple),
        _buildTechniqueCard("Pomodoro", Icons.timer,
            isDarkMode ? Colors.orangeAccent : Colors.deepOrangeAccent),
        _buildTechniqueCard("Time Blocking", Icons.schedule,
            isDarkMode ? Colors.tealAccent : Colors.teal),
        _buildTechniqueCard("Task Batching", Icons.assignment,
            isDarkMode ? Colors.lightBlueAccent : Colors.blue),
      ],
    );
  }

  Widget _buildTechniqueCard(String technique, IconData icon, Color cardColor) {
    return GestureDetector(
      onTap: () {
        if (technique == "Task Batching") {
          _navigateToTaskBatchingScreen();
        } else {
          _showNewRoutineDialog(technique);
        }
      },
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: cardColor,
        child: Container(
          height: 150,
          width: 180,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(1, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              Text(
                technique,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
                Text(
                  "Create a Routine for $technique",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
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
