import 'package:flutter/material.dart';
import 'routine_details_screen.dart';
import 'routine_screen.dart';

class RoutineList extends StatelessWidget {
  final List<Routine> routines;

  const RoutineList({super.key, required this.routines});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: routines.length,
      itemBuilder: (context, index) {
        final routine = routines[index];
        return Card(
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RoutineDetailsScreen(routine: routine),
                ),
              );
            },
            title: Text(routine.title),
            subtitle: Text(
              "${routine.dateTime.toLocal().toString().split(' ')[0]} at ${routine.dateTime.toLocal().toString().split(' ')[1].substring(0, 5)}",
            ),
          ),
        );
      },
    );
  }
}
