import 'package:flutter/material.dart';
import 'edit_dialog.dart';
import '../routine_screen.dart';

class EditButton extends StatelessWidget {
  final Routine routine;
  final Function(Routine) onRoutineUpdated;

  const EditButton({
    super.key,
    required this.routine,
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
        label: const Text(
          "Edit Routine",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
          onRoutineUpdated: onRoutineUpdated,
        );
      },
    );
  }

  ButtonStyle _elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.deepOrangeAccent,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
    );
  }
}
