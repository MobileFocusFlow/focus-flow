import 'package:flutter/material.dart';
import 'package:focusflow/temp_user_db.dart';
import 'components/language_select.dart';
import 'main.dart';
import 'routine_screen.dart';

class RoutineCreationForm extends StatefulWidget {
  final String workingTechnique;
  final Function(
          String, String, DateTime, String, int, int?, String, int, int, int)
      onRoutineCreated;

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
  int _workDuration = 0;
  int _breakDuration = 0;
  final String _postItNote = "";
  final int _priority = 0;
  final int _isImportant = -1;
  final int _isUrgent = -1;

  final _workDurationController = TextEditingController();
  final _breakDurationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _workDuration = widget.workingTechnique == Routine.pomodoroIdentifier
        ? 25
        : widget.workingTechnique == Routine.timeBlockingIdentifier
            ? 60
            : 0;
    _breakDuration =
        widget.workingTechnique == Routine.pomodoroIdentifier ? 5 : 0;
    _workDurationController.text = _workDuration.toString();
    _breakDurationController.text = _breakDuration.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ValueListenableBuilder<double>(
      valueListenable: FontSizeNotifier.fontSizeNotifier,
      builder: (context, fontSize, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: TextsInApp.getText(
                        "routine_c_form_routine_title") /*'Routine Title'*/,
                    labelStyle: TextStyle(
                      fontSize: fontSize,
                      color:
                          isDarkMode ? Colors.white : Colors.deepPurpleAccent,
                    ),
                    hintText: TextsInApp.getText(
                        "routine_c_form_hint_routine_title") /*'Enter your routine title'*/,
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[900] : Colors.blue[50],
                    prefixIcon: Icon(Icons.title,
                        color: isDarkMode
                            ? Colors.white
                            : Colors.deepPurpleAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color:
                            isDarkMode ? Colors.white : Colors.deepPurpleAccent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            isDarkMode ? Colors.white : Colors.deepPurpleAccent,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: fontSize,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
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
                      color:
                          isDarkMode ? Colors.white : Colors.deepPurpleAccent),
                  label: Text(
                    _selectedDate == null && _selectedTime == null
                        ? TextsInApp.getText(
                            "routine_c_form_set_reminder") /*"Set Reminder"*/
                        : "${TextsInApp.getText("routine_c_form_reminder")}${_selectedDate?.toLocal().toString().split(' ')[0]} ${_selectedTime?.format(context)}",
                    /*Reminder:*/
                    style: TextStyle(
                      fontSize: fontSize,
                      color:
                          isDarkMode ? Colors.white : Colors.deepPurpleAccent,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                        color: isDarkMode
                            ? Colors.white
                            : Colors.deepPurpleAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (widget.workingTechnique == Routine.pomodoroIdentifier) ...[
                  _buildDurationField(
                      TextsInApp.getText("work_dur") /*"Work Duration (min.)"*/,
                      _workDurationController,
                      Icons.timer,
                      fontSize,
                      isDarkMode),
                  const SizedBox(height: 16),
                  _buildDurationField(
                      TextsInApp.getText(
                          "break_dur") /*"Break Duration (min.)"*/,
                      _breakDurationController,
                      Icons.pause,
                      fontSize,
                      isDarkMode),
                  const SizedBox(height: 16),
                ],
                if (widget.workingTechnique ==
                    Routine.timeBlockingIdentifier) ...[
                  _buildDurationField(
                      TextsInApp.getText(
                          "block_dur") /*"Block Duration (min.)"*/,
                      _workDurationController,
                      Icons.lock_clock,
                      fontSize,
                      isDarkMode),
                  const SizedBox(height: 16),
                ],
                ElevatedButton.icon(
                  onPressed: _handleAddRoutine,
                  icon: const Icon(Icons.add, size: 24),
                  label: Text(
                    TextsInApp.getText(
                        "routine_c_form_add_routine") /*"Add Routine"*/,
                    style: TextStyle(fontSize: fontSize),
                  ),
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
      },
    );
  }

  Widget _buildDurationField(String label, TextEditingController controller,
      IconData icon, double fontSize, bool isDarkMode) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: fontSize,
          color: isDarkMode ? Colors.white : Colors.deepPurpleAccent,
        ),
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
      style: TextStyle(
          fontSize: fontSize, color: isDarkMode ? Colors.white : Colors.black),
      onChanged: (text) {
        setState(() {
          if (text.isNotEmpty) {
            if (controller == _workDurationController) {
              _workDuration = int.tryParse(text) ?? 25;
            } else if (controller == _breakDurationController) {
              _breakDuration = int.tryParse(text) ?? 5;
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

      String routineKey = _titleController.text +
          combinedDateTime.toString() +
          widget.workingTechnique;

      widget.onRoutineCreated(
          routineKey,
          _titleController.text,
          combinedDateTime,
          widget.workingTechnique,
          _workDuration,
          _breakDuration,
          _postItNote,
          _priority,
          _isImportant,
          _isUrgent);

      setState(() {
        Routine newRoutine = Routine(
            routineKey,
            _titleController.text,
            combinedDateTime,
            widget.workingTechnique,
            _workDuration,
            _breakDuration,
            _postItNote,
            _priority,
            _isImportant,
            _isUrgent);
        UserDatabase.addRoutine(newRoutine);
      });

      Navigator.pop(context);
    }
  }
}
