import 'package:flutter/material.dart';
import 'edit_dialog.dart';
import '../routine_screen.dart';
import 'language_select.dart';

class EditButton extends StatelessWidget {
  final Routine routine;
  final double fontSize;
  final bool isDarkMode;
  final Function(Routine) onRoutineUpdated;

  const EditButton({
    super.key,
    required this.routine,
    required this.fontSize,
    required this.isDarkMode,
    required this.onRoutineUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton.icon(
        onPressed: () => _showEditDialog(context),
        style: _elevatedButtonStyle(),
        icon: const Icon(Icons.edit, size: 22),
        label: Text(
          " ${TextsInApp.getText("edit_routine")} " /*"Edit Routine"*/,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return EditDialog(
          routine: routine,
          fontSize: fontSize,
          onRoutineUpdated: onRoutineUpdated,
        );
      },
    );
  }

  ButtonStyle _elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor:
          Routine.getTechniqueColor(routine.workingTechnique, isDarkMode),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
    );
  }
}
