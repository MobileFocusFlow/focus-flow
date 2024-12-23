import 'package:flutter/material.dart';

import 'components/language_select.dart';
import 'main.dart';
import 'routine_details_screen.dart';
import 'routine_screen.dart';
import 'temp_user_db.dart';

class CreatedRoutinesScreen extends StatefulWidget {
  final Function(Routine) onRoutineUpdated;

  const CreatedRoutinesScreen({super.key, required this.onRoutineUpdated});

  @override
  // ignore: library_private_types_in_public_api
  _CreatedRoutinesScreen createState() => _CreatedRoutinesScreen();
}

class _CreatedRoutinesScreen extends State<CreatedRoutinesScreen> {
  void _deleteRoutine(String key) {
    setState(() {
      UserDatabase.removeRoutine(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final List<Routine> routines = UserDatabase.getRoutines();
    final List<Routine> otherRoutines = routines
        .where((routine) =>
            routine.workingTechnique != Routine.timeBlockingIdentifier)
        .toList();

    return ValueListenableBuilder<double>(
        valueListenable: FontSizeNotifier.fontSizeNotifier,
        builder: (context, fontSize, child) {
          return ListView(
            children: [
              ...otherRoutines.map((routine) {
                final key = routine.title +
                    routine.dateTime.toString() +
                    routine.workingTechnique;
                Routine.getTechniqueIcon(routine.workingTechnique);

                Color customIconColor = Routine.getTechniqueColor(
                    routine.workingTechnique, isDarkMode);
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(
                      Routine.getTechniqueIcon(routine.workingTechnique),
                      color: customIconColor,
                    ),
                    title: Text(
                      routine.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: fontSize,
                      ),
                    ),
                    subtitle: Text(
                      "${TextsInApp.getText("scheduled")}: ${routine.dateTime.toLocal().toString().split(' ')[0]} ${TextsInApp.getText("at")} ${routine.dateTime.toLocal().toString().split(' ')[1].substring(0, 5)}",
                      style: TextStyle(
                        fontSize: fontSize - 2,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        _showDeleteDialog(context, key);
                      },
                    ),
                    onTap: () {
                      UserDatabase.lastSelectedRoutine = routine;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoutineDetailsScreen(
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
        });
  }

  void _showDeleteDialog(BuildContext context, String key) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(TextsInApp.getText(
            "routine_list_delete_routine") /*'Delete Routine'*/),
        content: Text(TextsInApp.getText(
            "routine_list_delete_routine_confirm") /*'Are you sure you want to delete this routine?'*/),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(TextsInApp.getText("cancel") /*'Cancel'*/),
          ),
          TextButton(
            onPressed: () {
              _deleteRoutine(key);
              Navigator.pop(context);
            },
            child: Text(TextsInApp.getText("delete") /*'Delete'*/),
          ),
        ],
      ),
    );
  }
}
