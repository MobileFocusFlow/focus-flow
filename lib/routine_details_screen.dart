import 'package:flutter/material.dart';
import 'components/routine_header.dart';
import 'components/edit_button.dart';
import 'components/action_button.dart';
import 'routine_screen.dart';

class RoutineDetailsScreen extends StatefulWidget {
  final List<Routine> routines;
  final Function(Routine) onRoutinesUpdated;

  const RoutineDetailsScreen({
    super.key,
    required this.routines,
    required this.onRoutinesUpdated,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RoutineDetailsScreenState createState() => _RoutineDetailsScreenState();
}

class _RoutineDetailsScreenState extends State<RoutineDetailsScreen> {
  late Routine routine;

  @override
  void initState() {
    super.initState();
    routine = widget.routines.first;
  }

  void _handleRoutineUpdated(Routine updatedRoutine) {
    setState(() {
      routine = updatedRoutine;
    });
    widget.onRoutinesUpdated(updatedRoutine);
  }

  Color _handleBackgroundColor(bool isDarkMode) {
    Color selectColor = Colors.redAccent;
    if (routine.workingTechnique == "Zen") {
      selectColor = isDarkMode ? Colors.purple : Colors.pinkAccent;
    } else if (routine.workingTechnique == "Pomodoro") {
      selectColor = isDarkMode ? Colors.deepOrangeAccent : Colors.orange;
    } else if (routine.workingTechnique == "Time Blocking") {
      selectColor = isDarkMode ? Colors.teal : Colors.blue;
    }
    return selectColor;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Routine Details"),
        backgroundColor: _handleBackgroundColor(isDarkMode),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            RoutineHeader(routine: routine),
            const SizedBox(height: 24),
            ActionButton(routine: routine),
            const SizedBox(height: 24),
            EditButton(
              routine: routine,
              onRoutineUpdated: _handleRoutineUpdated,
            ),
          ],
        ),
      ),
    );
  }
}
