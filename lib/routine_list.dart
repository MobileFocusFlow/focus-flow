import 'package:flutter/material.dart';
import 'routine_details_screen.dart';
import 'routine_screen.dart';

class RoutineList extends StatefulWidget {
  final List<Routine> routines;
  final Function(Routine) onRoutineUpdated;

  const RoutineList(
      {super.key, required this.routines, required this.onRoutineUpdated});

  @override
  // ignore: library_private_types_in_public_api
  _RoutineListState createState() => _RoutineListState();
}

class _RoutineListState extends State<RoutineList> {
  void _deleteRoutine(int index) {
    setState(() {
      widget.routines.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final List<Routine> timeBlockingRoutines = widget.routines
        .where((routine) => routine.workingTechnique == "Time Blocking")
        .toList();

    final List<Routine> otherRoutines = widget.routines
        .where((routine) => routine.workingTechnique != "Time Blocking")
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (timeBlockingRoutines.isNotEmpty)
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: ExpansionTile(
              title: const Row(
                children: [
                  Icon(Icons.work_history_outlined, color: Colors.blueAccent),
                  SizedBox(width: 10),
                  Text(
                    "Time Blocking",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              children: timeBlockingRoutines.map((routine) {
                final index = widget.routines.indexOf(routine);
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.blue),
                    title: Text(
                      routine.title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      "Scheduled: ${routine.dateTime.toLocal().toString().split(' ')[0]} at ${routine.dateTime.toLocal().toString().split(' ')[1].substring(0, 5)}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        _showDeleteDialog(context, index);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoutineDetailsScreen(
                            routines: [routine],
                            onRoutinesUpdated: (updatedRoutine) {
                              widget.onRoutineUpdated(updatedRoutine);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        if (otherRoutines.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              "Current Routines",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ...otherRoutines.map((routine) {
          final index = widget.routines.indexOf(routine);

          IconData customIcon;
          Color customIconColor;

          if (routine.workingTechnique == "Pomodoro") {
            customIcon = Icons.timer;
            customIconColor = Colors.orangeAccent;
          } else if (routine.workingTechnique == "Zen") {
            customIcon = Icons.self_improvement;
            customIconColor = Colors.deepPurple.shade500;
          } else {
            customIcon = Icons.task_alt;
            customIconColor = Colors.grey;
          }

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: ListTile(
              leading: Icon(
                customIcon,
                color: customIconColor,
              ),
              title: Text(
                routine.title,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                "Scheduled: ${routine.dateTime.toLocal().toString().split(' ')[0]} at ${routine.dateTime.toLocal().toString().split(' ')[1].substring(0, 5)}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  _showDeleteDialog(context, index);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoutineDetailsScreen(
                      routines: [routine],
                      onRoutinesUpdated: (updatedRoutine) {
                        widget.onRoutineUpdated(updatedRoutine);
                      },
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Routine'),
        content: const Text('Are you sure you want to delete this routine?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteRoutine(index);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
