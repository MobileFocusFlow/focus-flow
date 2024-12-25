import 'package:flutter/material.dart';
import 'package:focusflow/components/action_button.dart';
import 'package:focusflow/components/language_select.dart';
import 'package:focusflow/temp_user_db.dart';
import 'routine_screen.dart';

class TaskBatchingScreen extends StatefulWidget {
  const TaskBatchingScreen({super.key});

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
    customGroups = UserDatabase.getCustomGroups();
  }

  void _loadRoutines() {
    allRoutines = UserDatabase.getRoutines();
    groupedRoutines = _groupRoutinesByTechnique(allRoutines);
  }

  Map<String, List<Routine>> _groupRoutinesByTechnique(List<Routine> routines) {
    Map<String, List<Routine>> techniqueGroups = {};

    for (var routine in routines) {
      if (!techniqueGroups.containsKey(routine.workingTechnique)) {
        techniqueGroups[routine.workingTechnique] = [];
      }
      techniqueGroups[routine.workingTechnique]?.add(routine);
    }

    Map<String, List<Routine>> customGroups = UserDatabase.getCustomGroups();

    Set<Routine> customRoutinesSet = {};
    customGroups.forEach((key, group) {
      customRoutinesSet.addAll(group);
    });

    techniqueGroups.forEach((key, group) {
      group.removeWhere((routine) => customRoutinesSet.contains(routine));
    });

    return techniqueGroups;
  }

  void _addCustomGroup(String groupName) {
    setState(() {
      UserDatabase.addCustomGroup(groupName);
      customGroups = UserDatabase.getCustomGroups();
    });
  }

  void _addRoutineToCustomGroup(String groupName, Routine routine) {
    setState(() {
      UserDatabase.addRoutineToCustomGroup(groupName, routine);
      _removeRoutineFromDefaultGroup(routine.key);
      customGroups = UserDatabase.getCustomGroups();
    });
  }

  void _restoreRoutine(Routine routine) {
    setState(() {
      if (!groupedRoutines.containsKey(routine.workingTechnique)) {
        groupedRoutines[routine.workingTechnique] = [];
      }
      groupedRoutines[routine.workingTechnique]?.add(routine);
    });
  }

  void _removeRoutineFromCustomGroup(String groupName, String routineKey) {
    setState(() {
      UserDatabase.removeRoutineFromCustomGroup(groupName, routineKey);
      customGroups = UserDatabase.getCustomGroups();
    });
  }

  void _removeRoutineFromDefaultGroup(String routineKey) {
    setState(() {
      for (var routines in groupedRoutines.values) {
        routines.removeWhere((routine) => routine.key == routineKey);
      }
    });
  }

  void _deleteCustomGroup(String groupName) {
    setState(() {
      UserDatabase.deleteCustomGroup(groupName);
      customGroups = UserDatabase.getCustomGroups();
    });
  }

  void _deleteRoutine(String routineKey) {
    setState(() {
      UserDatabase.removeRoutine(routineKey);
      _loadRoutines();
      for (var group in customGroups.values) {
        group.removeWhere((routine) => routine.key == routineKey);
      }
    });
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
                  _buildGroupSectionTitle(TextsInApp.getText(
                      "technique_groups")), //"Technique Groups"
                  ..._buildDefaultGroups(),
                  const SizedBox(height: 20),
                  _buildGroupSectionTitle(
                      TextsInApp.getText("custom_groups")), //"Custom Groups"
                  ..._buildCustomGroups(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddGroupDialog(),
        icon: const Icon(Icons.group_add),
        label: Text(
          TextsInApp.getText("add_group") /*"Add Group"*/,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
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
        subtitle:
            "${routines.length} ${TextsInApp.getText("routines")}", // Routines
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
        subtitle:
            "${routines.length} ${TextsInApp.getText("routines")}", // Routines
        leadingIcon: Icons.folder,
        leadingIconColor: Colors.orange,
        children: [
          ...routines.map((routine) {
            return _buildRoutineTile(routine, groupName: groupName);
          }),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text(
              TextsInApp.getText("delete_group"), //"Delete Group",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
            ),
            onTap: () {
              for (var r in UserDatabase.getCustomGroups()[groupName]!) {
                _restoreRoutine(r);
              }
              _deleteCustomGroup(groupName);
            },
          ),
        ],
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
        ActionButton.navigateToScene(routine, context);
      },
      title: Text(
        routine.title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        "${TextsInApp.getText("scheduled")}: ${routine.dateTime.toLocal().toString().split(' ')[0]} ${TextsInApp.getText("at")} ${routine.dateTime.toLocal().toString().split(' ')[1].substring(0, 5)}",
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
                  color: Colors.green, size: 30),
              onPressed: () {
                _showAddToGroupDialog(routine);
              },
            ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              if (isDefaultGroup) {
                _deleteRoutine(routine.key);
              } else if (groupName != null) {
                _removeRoutineFromCustomGroup(groupName, routine.key);
                _restoreRoutine(routine);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showAddGroupDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(TextsInApp.getText("task_batching_add_custom_group")),
          /*"Add Custom Group"*/
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: TextsInApp.getText(
                  "task_batching_hint_group_name") /*"Enter group name"*/,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(TextsInApp.getText("cancel") /*"Cancel"*/),
            ),
            ElevatedButton(
              onPressed: () {
                final groupName = controller.text.trim();
                if (groupName.isNotEmpty) {
                  _addCustomGroup(groupName);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
              ),
              child: Text(
                TextsInApp.getText("add") /*"Add"*/,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddToGroupDialog(Routine routine) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(TextsInApp.getText(
              "task_batching_add_to_custom_group") /*"Add to Custom Group"*/),
          content: customGroups.isEmpty
              ? Text(TextsInApp.getText(
                  "task_batching_no_custom_group_available") /*"No custom groups available."*/)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: customGroups.keys.map((groupName) {
                    return ListTile(
                      style: ListTileStyle.list,
                      title: Text(groupName),
                      /*tileColor: isDarkMode
                          ? Colors.deepPurple.shade900
                          : Colors.deepOrange.shade600,*/
                      onTap: () {
                        _addRoutineToCustomGroup(groupName, routine);
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(TextsInApp.getText("cancel") /*"Cancel"*/),
            ),
          ],
        );
      },
    );
  }
}
