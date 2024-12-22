import 'package:flutter/material.dart';
import 'main.dart';
import 'pomodoro.dart';
import 'time_blocking_screen.dart';
import 'zen_screen.dart';

class Task {
  String name;
  String description;
  String technique;
  int workDuration;
  int breakDuration;
  int blockDuration;

  Task({
    required this.name,
    required this.description,
    this.technique = '',
    this.workDuration = 25,
    this.breakDuration = 5,
    this.blockDuration = 60,
  });
}

class TaskGroup {
  String name;
  List<Task> tasks;

  TaskGroup({required this.name, required this.tasks});
}

class TaskBatchingScreen extends StatefulWidget {
  const TaskBatchingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaskBatchingScreenState createState() => _TaskBatchingScreenState();
}

class _TaskBatchingScreenState extends State<TaskBatchingScreen> {
  final List<TaskGroup> _taskGroups = [];

  void _showAddOrEditTaskDialog(
      TaskGroup group, Task? taskToEdit, bool isDarkMode) {
    String taskName = taskToEdit?.name ?? '';
    String taskDescription = taskToEdit?.description ?? '';
    int workDuration = taskToEdit?.workDuration ?? 25;
    int breakDuration = taskToEdit?.breakDuration ?? 5;
    int blockDuration = taskToEdit?.blockDuration ?? 60;
    String technique = taskToEdit?.technique ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: taskToEdit == null
                  ? const Text("Add Task", style: TextStyle(color: Colors.blue))
                  : const Text("Edit Task",
                      style: TextStyle(color: Colors.orange)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        taskName = value;
                      },
                      controller: TextEditingController(text: taskName),
                      decoration: InputDecoration(
                        labelText: "Task Name",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      onChanged: (value) {
                        taskDescription = value;
                      },
                      controller: TextEditingController(text: taskDescription),
                      decoration: InputDecoration(
                        labelText: "Task Description",
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButton<String>(
                      value: technique.isEmpty ? null : technique,
                      hint: const Text("Select Technique (Optional)"),
                      items: <String>['Pomodoro', 'Time Blocking', 'Zen']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          technique = newValue ?? '';
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    if (technique == 'Pomodoro') ...[
                      TextFormField(
                        onChanged: (value) {
                          workDuration = int.tryParse(value) ?? 25;
                        },
                        controller: TextEditingController(
                            text: workDuration.toString()),
                        decoration: InputDecoration(
                          labelText: "Work Duration (min.)",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        onChanged: (value) {
                          breakDuration = int.tryParse(value) ?? 5;
                        },
                        controller: TextEditingController(
                            text: breakDuration.toString()),
                        decoration: InputDecoration(
                          labelText: "Break Duration (min.)",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                    if (technique == 'Time Blocking') ...[
                      TextFormField(
                        onChanged: (value) {
                          blockDuration = int.tryParse(value) ?? 60;
                        },
                        controller: TextEditingController(
                            text: blockDuration.toString()),
                        decoration: InputDecoration(
                          labelText: "Block Duration (min.)",
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:
                      const Text("Cancel", style: TextStyle(color: Colors.red)),
                ),
                TextButton(
                  onPressed: () {
                    if (taskName.isNotEmpty) {
                      if (taskToEdit == null) {
                        _addTaskToGroup(
                          group,
                          taskName,
                          taskDescription,
                          workDuration,
                          breakDuration,
                          blockDuration,
                          technique,
                        );
                      } else {
                        _editTask(
                          group,
                          taskToEdit,
                          taskName,
                          taskDescription,
                          workDuration,
                          breakDuration,
                          blockDuration,
                          technique,
                        );
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: taskToEdit == null
                      ? Text("Add Task",
                          style: TextStyle(
                              color: isDarkMode ? Colors.orange : Colors.blue))
                      : const Text("Save Changes",
                          style: TextStyle(color: Colors.green)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addTaskToGroup(
    TaskGroup group,
    String taskName,
    String taskDescription,
    int workDuration,
    int breakDuration,
    int blockDuration,
    String technique,
  ) {
    setState(() {
      group.tasks.add(Task(
        name: taskName,
        description: taskDescription,
        workDuration: workDuration,
        breakDuration: breakDuration,
        blockDuration: blockDuration,
        technique: technique,
      ));
    });
  }

  void _editTask(
    TaskGroup group,
    Task taskToEdit,
    String taskName,
    String taskDescription,
    int workDuration,
    int breakDuration,
    int blockDuration,
    String technique,
  ) {
    setState(() {
      taskToEdit.name = taskName;
      taskToEdit.description = taskDescription;
      taskToEdit.workDuration = workDuration;
      taskToEdit.breakDuration = breakDuration;
      taskToEdit.blockDuration = blockDuration;
      taskToEdit.technique = technique;
    });
  }

  void _showAddTaskGroupDialog() {
    String groupName = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create Task Group",
              style: TextStyle(color: Colors.green)),
          content: TextFormField(
            onChanged: (value) {
              groupName = value;
            },
            decoration: const InputDecoration(labelText: "Group Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                if (groupName.isNotEmpty) {
                  _addTaskGroup(groupName);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add Group",
                  style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _addTaskGroup(String groupName) {
    setState(() {
      _taskGroups.add(TaskGroup(name: groupName, tasks: []));
    });
  }

  void _deleteTaskGroup(TaskGroup group) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Group'),
          content: Text(
              'Are you sure you want to delete the group "${group.name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _taskGroups.remove(group);
                });
                Navigator.pop(context);
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ThemeNotifier.themeNotifier.value == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Batching", style: TextStyle(fontSize: 24)),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: 40,
            onPressed: _showAddTaskGroupDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _taskGroups.length,
          itemBuilder: (context, index) {
            final group = _taskGroups[index];

            return Card(
              elevation: 4, // Adding elevation to make the card raised
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  backgroundColor: isDarkMode
                      ? Colors.indigo.shade600
                      : Colors.amber.shade600,
                  title: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.teal, width: 1)),
                    ),
                    child: Text(
                      group.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  children: [
                    ...group.tasks.map((task) => Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 10),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                            color: isDarkMode
                                ? Colors.indigo.shade800
                                : Colors.amber.shade800,
                          ),
                          child: ListTile(
                            title: Text(
                                "${task.name} with ${task.technique.isEmpty ? "Zen" : task.technique}"),
                            subtitle: Text(task.description),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      group.tasks.remove(task);
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () {
                                    _showAddOrEditTaskDialog(
                                        group, task, isDarkMode);
                                  },
                                ),
                              ],
                            ),
                            onTap: task.technique.isEmpty
                                ? null
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            _buildWorkingTechniqueScreen(task),
                                      ),
                                    );
                                  },
                          ),
                        )),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ListTile(
                        title: const Text("Add Task",
                            style: TextStyle(color: Colors.blue)),
                        leading: const Icon(Icons.add, color: Colors.blue),
                        onTap: () {
                          _showAddOrEditTaskDialog(group, null, isDarkMode);
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 32,
                          ),
                          onPressed: () {
                            _deleteTaskGroup(group);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWorkingTechniqueScreen(Task task) {
    switch (task.technique) {
      case 'Pomodoro':
        return PomodoroScreen(
          taskName: task.name,
          workDuration: task.workDuration * 60,
          breakDuration: task.breakDuration * 60,
        );
      case 'Time Blocking':
        return TimeBlockingScreen(
          taskName: task.name,
          blockDuration: task.blockDuration * 60,
        );
      case 'Zen':
        return ZenScreen(taskName: task.name);
      default:
        return Container();
    }
  }
}
