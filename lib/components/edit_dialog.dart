import 'package:flutter/material.dart';
import '../routine_screen.dart';

class EditDialog extends StatefulWidget {
  final Routine routine;
  final Function(Routine) onRoutineUpdated;

  const EditDialog({
    super.key,
    required this.routine,
    required this.onRoutineUpdated,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  late Routine routine;
  late TextEditingController reminderController;
  late TextEditingController workDurationController;
  late TextEditingController breakDurationController;
  late TextEditingController blockDurationController;
  late String selectedTechnique;

  @override
  void initState() {
    super.initState();
    routine = widget.routine;
    reminderController =
        TextEditingController(text: _formatDateTime(routine.dateTime));
    workDurationController =
        TextEditingController(text: routine.workDuration.toString());
    breakDurationController =
        TextEditingController(text: routine.breakDuration.toString());
    blockDurationController =
        TextEditingController(text: routine.blockDuration.toString());
    selectedTechnique = routine.workingTechnique;
  }

  @override
  void dispose() {
    reminderController.dispose();
    workDurationController.dispose();
    breakDurationController.dispose();
    blockDurationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text("Edit Routine"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDateTimePicker(context),
            const SizedBox(height: 16),
            _buildTechniqueDropdown(),
            if (selectedTechnique == 'Pomodoro') ...[
              const SizedBox(height: 16),
              _buildDurationField(
                "Work Duration (minutes)",
                workDurationController,
                isWorkDuration: true,
              ),
              const SizedBox(height: 16),
              _buildDurationField(
                "Break Duration (minutes)",
                breakDurationController,
                isWorkDuration: false,
              ),
            ],
            if (selectedTechnique == 'Time Blocking') ...[
              const SizedBox(height: 16),
              _buildDurationField(
                "Block Duration (minutes)",
                blockDurationController,
                isWorkDuration: false,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _saveRoutineUpdates,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrangeAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text("Save"),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker(BuildContext context) {
    return TextField(
      controller: reminderController,
      readOnly: true,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: "Reminder Date and Time",
        labelStyle: const TextStyle(color: Colors.deepOrangeAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon:
            const Icon(Icons.calendar_today, color: Colors.deepOrangeAccent),
      ),
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: routine.dateTime,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (selectedDate != null) {
          TimeOfDay? selectedTime = await showTimePicker(
            // ignore: use_build_context_synchronously
            context: context,
            initialTime: TimeOfDay.fromDateTime(routine.dateTime),
          );

          if (selectedTime != null) {
            setState(() {
              routine.dateTime = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );
              reminderController.text = _formatDateTime(routine.dateTime);
            });
          }
        }
      },
    );
  }

  Widget _buildTechniqueDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedTechnique,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedTechnique = newValue;
            routine.workingTechnique = newValue;
          });
        }
      },
      decoration: InputDecoration(
        labelText: "Working Technique",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      items: ['Zen', 'Pomodoro', 'Time Blocking']
          .map((technique) =>
              DropdownMenuItem(value: technique, child: Text(technique)))
          .toList(),
    );
  }

  Widget _buildDurationField(
    String label,
    TextEditingController controller, {
    required bool isWorkDuration,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onChanged: (value) {
        setState(() {
          int? duration = int.tryParse(value);
          int defaultPomodoroWorkDur = 25,
              defaultPomodoroBreakDur = 5,
              defaultTimeBlockingDur = 60;

          if (selectedTechnique == 'Pomodoro') {
            if (isWorkDuration) {
              routine.workDuration = duration ?? defaultPomodoroWorkDur;
            } else {
              routine.breakDuration = duration ?? defaultPomodoroBreakDur;
            }
          } else if (selectedTechnique == 'Time Blocking') {
            routine.blockDuration = duration ?? defaultTimeBlockingDur;
          }
        });
      },
    );
  }

  void _saveRoutineUpdates() {
    widget.onRoutineUpdated(routine);
    Navigator.of(context).pop();
  }

  String _formatDateTime(DateTime dateTime) =>
      "${dateTime.toLocal().toString().split(' ')[0]} at ${dateTime.toLocal().toString().split(' ')[1].substring(0, 5)}";
}
