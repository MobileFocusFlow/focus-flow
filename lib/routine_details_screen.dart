import 'package:flutter/material.dart';
import 'package:focusflow/components/post_it_note.dart';
import 'package:focusflow/temp_user_db.dart';
import 'components/language_select.dart';
import 'components/routine_header.dart';
import 'components/edit_button.dart';
import 'components/action_button.dart';
import 'main.dart';
import 'routine_screen.dart';

class RoutineDetailsScreen extends StatefulWidget {
  final Function(Routine) onRoutinesUpdated;

  const RoutineDetailsScreen({
    super.key,
    required this.onRoutinesUpdated,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RoutineDetailsScreenState createState() => _RoutineDetailsScreenState();
}

class _RoutineDetailsScreenState extends State<RoutineDetailsScreen> {
  late Routine selectedRoutine;

  @override
  void initState() {
    super.initState();
    selectedRoutine = UserDatabase.lastSelectedRoutine;
  }

  void _handleRoutineUpdated(Routine updatedRoutine) {
    setState(() {
      selectedRoutine = updatedRoutine;
    });
    widget.onRoutinesUpdated(updatedRoutine);
  }

  Color _handleBackgroundColor(bool isDarkMode) {
    Map<String, Color> techniqueColors = {
      Routine.zenIdentifier:
          Routine.getTechniqueColor(Routine.zenIdentifier, isDarkMode),
      Routine.pomodoroIdentifier:
          Routine.getTechniqueColor(Routine.pomodoroIdentifier, isDarkMode),
      Routine.timeBlockingIdentifier:
          Routine.getTechniqueColor(Routine.timeBlockingIdentifier, isDarkMode),
    };

    return techniqueColors[selectedRoutine.workingTechnique] ??
        Colors.redAccent;
  }

  void _savePostItText(String text) {
    setState(() {
      UserDatabase.lastSelectedRoutine.postItNote = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<double>(
      valueListenable: FontSizeNotifier.fontSizeNotifier,
      builder: (context, fontSize, child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              TextsInApp.getText("routine_details_routine_details"),
              style: TextStyle(fontSize: fontSize + 2),
            ),
            backgroundColor: _handleBackgroundColor(isDarkMode),
            centerTitle: true,
            elevation: 4,
          ),
          backgroundColor: isDarkMode ? Colors.black : Colors.blue.shade300,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildRoutineDetailsSection(isDarkMode, fontSize),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildPostItNoteSection(isDarkMode),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildRoutineDetailsSection(bool isDarkMode, double fontSize) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: _getGradient(isDarkMode),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RoutineHeader(
            routine: selectedRoutine,
            fontSize: fontSize,
          ),
          const SizedBox(height: 20),
          ActionButton(
            routine: selectedRoutine,
            fontSize: fontSize,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 20),
          EditButton(
            routine: selectedRoutine,
            onRoutineUpdated: _handleRoutineUpdated,
            isDarkMode: isDarkMode,
            fontSize: fontSize,
          ),
        ],
      ),
    );
  }

  Widget _buildPostItNoteSection(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: _getGradient(isDarkMode),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: PostItNote(
          onSave: _savePostItText,
        ),
      ),
    );
  }

  LinearGradient _getGradient(bool isDarkMode) {
    return LinearGradient(
      colors: isDarkMode
          ? [Colors.grey.shade900, Colors.black54, Colors.grey.shade900]
          : [Colors.blue.shade100, Colors.blue.shade200, Colors.blue.shade300],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
