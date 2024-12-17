import 'package:flutter/material.dart';
import '../routine_screen.dart';

class RoutineHeader extends StatelessWidget {
  final Routine routine;

  const RoutineHeader({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Text(
          routine.title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.deepOrange,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Scheduled for",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? Colors.grey.shade300
                            : Colors.grey.shade700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDateTime(routine.dateTime),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color:
                            isDarkMode ? Colors.grey.shade100 : Colors.black87,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) =>
      "${dateTime.toLocal().toString().split(' ')[0]} at ${dateTime.toLocal().toString().split(' ')[1].substring(0, 5)}";
}
