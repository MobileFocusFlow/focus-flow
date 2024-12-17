import 'package:flutter/material.dart';

class RoutineCreationForm extends StatefulWidget {
  final String workingTechnique;
  final Function(String, DateTime, String, int, int?) onRoutineCreated;

  const RoutineCreationForm({
    super.key,
    required this.workingTechnique,
    required this.onRoutineCreated,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RoutineCreationFormState createState() => _RoutineCreationFormState();
}

class _RoutineCreationFormState extends State<RoutineCreationForm> {
  final _titleController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _workDuration = 25;
  int _breakDuration = 5;
  int _blockDuration = 60;

  final _workDurationController = TextEditingController();
  final _breakDurationController = TextEditingController();
  final _blockDurationController = TextEditingController();
  //initialization
  @override
  void initState() {
    super.initState();

    _workDurationController.text = _workDuration.toString();
    _breakDurationController.text = _breakDuration.toString();
    _blockDurationController.text = _blockDuration.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the colors based on the current theme
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Routine Title',
                labelStyle: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.deepPurpleAccent),
                hintText: 'Enter your routine title',
                filled: true,
                fillColor: isDarkMode ? Colors.grey[900] : Colors.blue[50],
                prefixIcon: Icon(Icons.title,
                    color: isDarkMode ? Colors.white : Colors.deepPurpleAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                      color:
                          isDarkMode ? Colors.white : Colors.deepPurpleAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color:
                          isDarkMode ? Colors.white : Colors.deepPurpleAccent),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () async {
                _selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (_selectedDate != null) {
                  _selectedTime = await showTimePicker(
                    // ignore: use_build_context_synchronously
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                }

                setState(() {});
              },
              icon: Icon(Icons.calendar_today,
                  color: isDarkMode ? Colors.white : Colors.deepPurpleAccent),
              label: Text(
                _selectedDate == null && _selectedTime == null
                    ? "Set Reminder"
                    : "Reminder: ${_selectedDate?.toLocal().toString().split(' ')[0]} ${_selectedTime?.format(context)}",
                style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.deepPurpleAccent),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(
                    color: isDarkMode ? Colors.white : Colors.deepPurpleAccent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (widget.workingTechnique == "Pomodoro") ...[
              _buildDurationField("Work Duration (min.)",
                  _workDurationController, Icons.timer, isDarkMode),
              const SizedBox(height: 16),
              _buildDurationField("Break Duration (min.)",
                  _breakDurationController, Icons.pause, isDarkMode),
              const SizedBox(height: 16),
            ],
            if (widget.workingTechnique == "Time Blocking") ...[
              _buildDurationField("Block Duration (min.)",
                  _blockDurationController, Icons.lock_clock, isDarkMode),
              const SizedBox(height: 16),
            ],
            ElevatedButton.icon(
              onPressed: _handleAddRoutine,
              icon: const Icon(Icons.add, size: 24),
              label: const Text("Add Routine"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationField(String label, TextEditingController controller,
      IconData icon, bool isDarkMode) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: isDarkMode ? Colors.white : Colors.deepPurpleAccent),
        prefixIcon: Icon(icon,
            color: isDarkMode ? Colors.white : Colors.deepPurpleAccent),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[900] : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isDarkMode ? Colors.white : Colors.deepPurpleAccent),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      onChanged: (text) {
        setState(() {
          if (text.isNotEmpty) {
            int value = int.tryParse(text) ?? 0;
            if (controller == _workDurationController) {
              _workDuration = value;
            } else if (controller == _breakDurationController) {
              _breakDuration = value;
            } else if (controller == _blockDurationController) {
              _blockDuration = value;
            }
          }
        });
      },
    );
  }

  void _handleAddRoutine() {
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

      int selectedActiveDur = 10;
      if (widget.workingTechnique == "Pomodoro") {
        selectedActiveDur = _workDuration;
      } else if (widget.workingTechnique == "Time Blocking") {
        selectedActiveDur = _blockDuration;
      }

      widget.onRoutineCreated(
        _titleController.text,
        combinedDateTime,
        widget.workingTechnique,
        selectedActiveDur,
        widget.workingTechnique == "Pomodoro" ? _breakDuration : null,
      );

      Navigator.pop(context);
    }
  }
}
