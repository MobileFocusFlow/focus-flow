import 'package:flutter/material.dart';
import 'package:focusflow/components/language_select.dart';
import 'package:focusflow/routine_details_screen.dart';
import 'package:focusflow/temp_user_db.dart';
import 'routine_screen.dart';

class TaskBatchingScreen extends StatefulWidget {
  final Function(Routine) onRoutineUpdated;

  const TaskBatchingScreen({super.key, required this.onRoutineUpdated});

  @override
  TaskBatchingScreenState createState() => TaskBatchingScreenState();
}

class TaskBatchingScreenState extends State<TaskBatchingScreen> {
  late List<Routine> allRoutines;
  late Map<String, List<Routine>> groupedRoutines;
  late Map<String, List<Routine>> customGroups;

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  void _loadRoutines() {
    allRoutines = UserDatabase.getRoutines();
    groupedRoutines = _groupRoutinesByTechnique(allRoutines);
    customGroups = _groupRoutinesByCustomGroup(allRoutines);
  }

  Map<String, List<Routine>> _groupRoutinesByTechnique(List<Routine> routines) {
    Map<String, List<Routine>> techniqueGroups = {};

    for (var routine in routines) {
      if (routine.customGroup.isNotEmpty) continue;

      if (!techniqueGroups.containsKey(routine.workingTechnique)) {
        techniqueGroups[routine.workingTechnique] = [];
      }
      techniqueGroups[routine.workingTechnique]!.add(routine);
    }

    return techniqueGroups;
  }

  Map<String, List<Routine>> _groupRoutinesByCustomGroup(
      List<Routine> routines) {
    Map<String, List<Routine>> customGroupMap = {};

    for (var routine in routines) {
      if (routine.customGroup.isNotEmpty) {
        customGroupMap.putIfAbsent(routine.customGroup, () => []);
        customGroupMap[routine.customGroup]!.add(routine);
      }
    }

    return customGroupMap;
  }

  void _addCustomGroup(String groupName) {
    setState(() {
      customGroups[groupName] = [];
    });
  }

  void _addRoutineToCustomGroup(String groupName, Routine routine) {
    setState(() {
      if (routine.customGroup.isNotEmpty) {
        customGroups[routine.customGroup]?.remove(routine);
        if (customGroups[routine.customGroup]?.isEmpty == true) {
          customGroups.remove(routine.customGroup);
        }
      }

      routine.customGroup = groupName;
      customGroups.putIfAbsent(groupName, () => []);
      customGroups[groupName]!.add(routine);

      _removeRoutineFromDefaultGroup(routine.key);
    });
    // Save to database
  }

  void _removeRoutineFromCustomGroup(String groupName, String routineKey) {
    setState(() {
      final routine = customGroups[groupName]!
          .firstWhere((routine) => routine.key == routineKey);
      routine.customGroup = "";
      customGroups[groupName]!
          .removeWhere((routine) => routine.key == routineKey);

      if (customGroups[groupName]!.isEmpty) {
        customGroups.remove(groupName);
      }

      if (!groupedRoutines.containsKey(routine.workingTechnique)) {
        groupedRoutines[routine.workingTechnique] = [];
      }
      groupedRoutines[routine.workingTechnique]!.add(routine);
    });
    // Save to database
  }

  void _removeRoutineFromDefaultGroup(String routineKey) {
    for (var routines in groupedRoutines.values) {
      routines.removeWhere((routine) => routine.key == routineKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          TextsInApp.getTechniqueNameWithLanguage(
              Routine.taskBatchingIdentifier),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Routine.getTechniqueColor(
            Routine.taskBatchingIdentifier, isDarkMode),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildGroupSectionTitle(
                      TextsInApp.getText("technique_groups")),
                  ..._buildDefaultGroups(),
                  const SizedBox(height: 20),
                  _buildGroupSectionTitle(TextsInApp.getText("custom_groups")),
                  ..._buildCustomGroups(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.layers, color: Colors.deepPurpleAccent),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDefaultGroups() {
    return groupedRoutines.entries.map((entry) {
      final technique = entry.key;
      final routines = entry.value;

      return _buildStylishCard(
        title: technique,
        subtitle: "${routines.length} ${TextsInApp.getText("routines")}",
        leadingIcon: Routine.getTechniqueIcon(technique),
        leadingIconColor: Routine.getTechniqueColor(technique, false),
        children: routines.map((routine) {
          return _buildRoutineTile(routine, isDefaultGroup: true);
        }).toList(),
      );
    }).toList();
  }

  List<Widget> _buildCustomGroups() {
    return customGroups.entries.map((entry) {
      final groupName = entry.key;
      final routines = entry.value;

      return _buildStylishCard(
        title: groupName,
        subtitle: "${routines.length} ${TextsInApp.getText("routines")}",
        leadingIcon: Icons.folder,
        leadingIconColor: Colors.orange,
        children: routines.map((routine) {
          return _buildRoutineTile(routine, groupName: groupName);
        }).toList(),
      );
    }).toList();
  }

  Widget _buildStylishCard({
    required String title,
    required String subtitle,
    required IconData leadingIcon,
    required Color leadingIconColor,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: leadingIconColor.withOpacity(0.2),
          child: Icon(leadingIcon, color: leadingIconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(subtitle),
        children: children,
      ),
    );
  }

  Widget _buildRoutineTile(Routine routine,
      {bool isDefaultGroup = false, String? groupName}) {
    return ListTile(
      onTap: () {
        UserDatabase.lastSelectedRoutine = routine;
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoutineDetailsScreen(
                onRoutinesUpdated: (updatedRoutine) {
                  widget.onRoutineUpdated(updatedRoutine);
                },
              ),
            ));
      },
      title: Text(
        routine.title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        "${routine.dateTime.toLocal().toString().split(' ')[0]} ${TextsInApp.getText("at")} ${routine.dateTime.toLocal().toString().split(' ')[1].substring(0, 5)}",
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDefaultGroup)
            IconButton(
              icon: const Icon(Icons.arrow_forward,
                  color: Colors.green, size: 32),
              onPressed: () {
                _showAddToGroupDialog(routine);
              },
            ),
          if (!isDefaultGroup && groupName != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _removeRoutineFromCustomGroup(groupName, routine.key);
              },
            ),
        ],
      ),
    );
  }

  void _showAddToGroupDialog(Routine routine) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(TextsInApp.getText("task_batching_add_to_custom_group")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (customGroups.isNotEmpty)
                ...customGroups.keys.map((groupName) {
                  return ListTile(
                    title: Text(groupName),
                    onTap: () {
                      _addRoutineToCustomGroup(groupName, routine);
                      Navigator.pop(context);
                    },
                  );
                }),
              ListTile(
                leading: Icon(Icons.add, color: Colors.deepPurpleAccent),
                title:
                    Text(TextsInApp.getText("task_batching_create_new_group")),
                onTap: () {
                  Navigator.pop(context);
                  _showCreateGroupDialog(routine);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(TextsInApp.getText("cancel")),
            ),
          ],
        );
      },
    );
  }

  void _showCreateGroupDialog(Routine routine) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(TextsInApp.getText("task_batching_add_custom_group")),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: TextsInApp.getText("task_batching_hint_group_name"),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(TextsInApp.getText("cancel")),
            ),
            ElevatedButton(
              onPressed: () {
                final groupName = controller.text.trim();
                if (groupName.isNotEmpty) {
                  _addCustomGroup(groupName);
                  _addRoutineToCustomGroup(groupName, routine);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
              ),
              child: Text(
                TextsInApp.getText("add"),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
