import 'package:flutter/material.dart';

class RoutineCreationForm extends StatefulWidget {
  final Function(String, DateTime, String, int, int) onRoutineCreated;

  const RoutineCreationForm({super.key, required this.onRoutineCreated});

  @override
  _RoutineCreationFormState createState() => _RoutineCreationFormState();
}

class _RoutineCreationFormState extends State<RoutineCreationForm> {
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedTechnique = "None"; // Default to "None"
  int _workDuration = 25; // Default to 25 minutes
  int _breakDuration = 5; // Default to 5 minutes

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: "Routine Title"),
        ),
        const SizedBox(height: 16),
        DropdownButton<String>(
          value: _selectedTechnique,
          onChanged: (String? newValue) {
            setState(() {
              _selectedTechnique = newValue!;
            });
          },
          items: <String>['None', 'Pomodoro']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () async {
            _selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            setState(() {}); // Trigger a UI update to display selected date
          },
          child: Text(_selectedDate == null
              ? "Select Date"
              : "${_selectedDate!.toLocal().toString().split(' ')[0]}"),
        ),
        OutlinedButton(
          onPressed: () async {
            _selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            setState(() {}); // Trigger a UI update to display selected time
          },
          child: Text(_selectedTime == null
              ? "Select Time"
              : _selectedTime!.format(context)),
        ),
        const SizedBox(height: 16),
        if (_selectedTechnique == "Pomodoro") ...[
          // Only show the work and break duration fields if Pomodoro is selected
          TextField(
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: "Work Duration (minutes)"),
            onChanged: (value) {
              setState(() {
                _workDuration = int.tryParse(value) ??
                    25; // Default to 25 minutes if invalid
              });
            },
          ),
          const SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.number,
            decoration:
                const InputDecoration(labelText: "Break Duration (minutes)"),
            onChanged: (value) {
              setState(() {
                _breakDuration =
                    int.tryParse(value) ?? 5; // Default to 5 minutes if invalid
              });
            },
          ),
        ],
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              _selectedDate ??= DateTime.now();
              _selectedTime ??= TimeOfDay.now();

              final combinedDateTime = DateTime(
                _selectedDate!.year,
                _selectedDate!.month,
                _selectedDate!.day,
                _selectedTime!.hour,
                _selectedTime!.minute,
              );

              widget.onRoutineCreated(
                _titleController.text,
                combinedDateTime,
                _selectedTechnique,
                _workDuration,
                _breakDuration,
              );
            }
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}
