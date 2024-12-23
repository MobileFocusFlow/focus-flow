import 'package:flutter/material.dart';
import 'package:focusflow/temp_user_db.dart';
import 'components/language_select.dart';
import 'main.dart';
import 'routine_details_screen.dart';
import 'routine_screen.dart';

class RoutineList extends StatefulWidget {
  final Function(Routine) onRoutineUpdated;

  const RoutineList({super.key, required this.onRoutineUpdated});

  @override
  // ignore: library_private_types_in_public_api
  _RoutineListState createState() => _RoutineListState();
}

class _RoutineListState extends State<RoutineList> {
  void _deleteRoutine(String key) {
    setState(() {
      UserDatabase.removeRoutine(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final List<Routine> routines = UserDatabase.getRoutines();
    final List<Routine> timeBlockingRoutines = routines
        .where((routine) =>
            routine.workingTechnique == Routine.timeBlockingIdentifier)
        .toList();
    final List<Routine> otherRoutines = routines
        .where((routine) =>
            routine.workingTechnique != Routine.timeBlockingIdentifier)
        .toList();

    return ValueListenableBuilder<double>(
      valueListenable: FontSizeNotifier.fontSizeNotifier,
      builder: (context, fontSize, child) {
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
                  title: Row(
                    children: [
                      Icon(Icons.work_history_outlined,
                          color: Routine.getTechniqueColor(
                              Routine.timeBlockingIdentifier, isDarkMode)),
                      const SizedBox(width: 10),
                      Text(
                        Routine.timeBlockingIdentifier,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                        ),
                      ),
                    ],
                  ),
                  children: timeBlockingRoutines.map((routine) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.access_time,
                            color: Routine.getTechniqueColor(
                                Routine.timeBlockingIdentifier, isDarkMode)),
                        title: Text(
                          routine.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: fontSize,
                          ),
                        ),
                        subtitle: Text(
                          //"Scheduled: ${routine.dateTime.toLocal().toString().split(' ')[0]} at ${routine.dateTime.toLocal().toString().split(' ')[1].substring(0, 5)}"
                          "${TextsInApp.getText("scheduled")} ${routine.dateTime.toLocal().toString().split(' ')[0]} ${TextsInApp.getText("at")} ${routine.dateTime.toLocal().toString().split(' ')[1].substring(0, 5)}",
                          style: TextStyle(
                            fontSize: fontSize - 1,
                            color: Colors.grey,
                          ),
                        ),
                        trailing: IconButton(
                          icon:
                              const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            final key = routine.title +
                                routine.dateTime.toString() +
                                routine.workingTechnique;
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
                  }).toList(),
                ),
              ),
            if (otherRoutines.isNotEmpty)
              ...otherRoutines.map((routine) {
                final key = routine.title +
                    routine.dateTime.toString() +
                    routine.workingTechnique;

                Color customIconColor = Routine.getTechniqueColor(
                    routine.workingTechnique, isDarkMode);

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  child: SizedBox(
                    width: 425,
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
                        "${TextsInApp.getText("scheduled")} ${routine.dateTime.toLocal().toString().split(' ')[0]} ${TextsInApp.getText("at")} ${routine.dateTime.toLocal().toString().split(' ')[1].substring(0, 5)}",
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
                  ),
                );
              }),
          ],
        );
      },
    );
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
