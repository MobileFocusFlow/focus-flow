import 'package:flutter/material.dart';
import 'routine_creation_form.dart';
import 'routine_list.dart';
import 'notification_service.dart';

class Routine {
  final String title;
  final DateTime dateTime;
  final String workingTechnique;
  final int workDuration;
  final int breakDuration;

  Routine(this.title, this.dateTime, this.workingTechnique, this.workDuration,
      this.breakDuration);
}

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  RoutineScreenState createState() => RoutineScreenState();
}

class RoutineScreenState extends State<RoutineScreen> {
  final List<Routine> _routines = [];

  void _addRoutine(String title, DateTime dateTime, String workingTechnique,
      int workDuration, int breakDuration) {
    final routine = Routine(
      title,
      dateTime,
      workingTechnique,
      workDuration,
      breakDuration,
    );
    setState(() {
      _routines.add(routine);
    });

    // Schedule the notification (use web notifications as an example)
    showWebNotification(
      'Routine Reminder: $title',
      'It\'s time for your routine: $title',
      dateTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Routines")),
      body: RoutineList(routines: _routines),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("New Routine"),
              content: RoutineCreationForm(
                onRoutineCreated: _addRoutine,
              ),
            );
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
