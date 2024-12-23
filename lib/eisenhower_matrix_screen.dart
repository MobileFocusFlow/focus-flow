import 'package:flutter/material.dart';
import 'package:focusflow/components/language_select.dart';

class EisenhowerMatrixScreen extends StatefulWidget {
  const EisenhowerMatrixScreen({super.key});

  @override
  EisenhowerMatrixScreenState createState() => EisenhowerMatrixScreenState();
}

class EisenhowerMatrixScreenState extends State<EisenhowerMatrixScreen> {
  final List<String> _urgentImportantTasks = [];
  final List<String> _importantNotUrgentTasks = [];
  final List<String> _urgentNotImportantTasks = [];
  final List<String> _notUrgentNotImportantTasks = [];

  final TextEditingController _taskController = TextEditingController();
  String _selectedCategory = "Urgent & Important";

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_taskController.text.isEmpty) return;

    setState(() {
      switch (_selectedCategory) {
        case "Urgent & Important":
          _urgentImportantTasks.add(_taskController.text);
          break;
        case "Important but Not Urgent":
          _importantNotUrgentTasks.add(_taskController.text);
          break;
        case "Urgent but Not Important":
          _urgentNotImportantTasks.add(_taskController.text);
          break;
        case "Not Urgent & Not Important":
          _notUrgentNotImportantTasks.add(_taskController.text);
          break;
      }
      _taskController.clear();
    });
  }

  void _editTask(String category, int index) {
    final TextEditingController editController = TextEditingController(
      text: _getTaskList(category)[index],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: "Task"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _getTaskList(category)[index] = editController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text(TextsInApp.getText("save")), //"Save"
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(String category, int index) {
    setState(() {
      _getTaskList(category).removeAt(index);
    });
  }

  List<String> _getTaskList(String category) {
    switch (category) {
      case "Urgent & Important":
        return _urgentImportantTasks;
      case "Important but Not Urgent":
        return _importantNotUrgentTasks;
      case "Urgent but Not Important":
        return _urgentNotImportantTasks;
      case "Not Urgent & Not Important":
        return _notUrgentNotImportantTasks;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Eisenhower Matrix"),
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: <String>[
                "Urgent & Important",
                "Important but Not Urgent",
                "Urgent but Not Important",
                "Not Urgent & Not Important"
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(labelText: "New Task"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addTask,
              child: const Text("Add Task"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _buildTaskColumn("Urgent & Important", _urgentImportantTasks),
                  _buildTaskColumn(
                      "Important but Not Urgent", _importantNotUrgentTasks),
                  _buildTaskColumn(
                      "Urgent but Not Important", _urgentNotImportantTasks),
                  _buildTaskColumn("Not Urgent & Not Important",
                      _notUrgentNotImportantTasks),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskColumn(String category, List<String> tasks) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              category,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(tasks[index]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editTask(category, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteTask(category, index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
