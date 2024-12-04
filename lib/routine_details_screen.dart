import 'package:flutter/material.dart';
import 'pomodoro_screen.dart';
import 'routine_screen.dart';

class RoutineDetailsScreen extends StatelessWidget {
  final Routine routine;

  const RoutineDetailsScreen({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Routine Details"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Routine title with styling
            Text(
              routine.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrangeAccent,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Scheduled date and time
            Text(
              "Scheduled for: ${routine.dateTime.toLocal().toString().split(' ')[0]} at ${routine.dateTime.toLocal().toString().split(' ')[1].substring(0, 5)}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Action button to start Pomodoro session
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PomodoroScreen(
                          taskName: routine.title,
                          workDuration: routine.workDuration * 60,
                          breakDuration: routine.breakDuration * 60),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation:
                      5, // Adding elevation for better material design look
                ),
                child: const Text(
                  "Handle with Pomodoro",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
