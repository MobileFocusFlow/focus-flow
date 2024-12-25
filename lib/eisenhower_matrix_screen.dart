import 'package:flutter/material.dart';
import 'package:focusflow/components/language_select.dart';
import 'package:focusflow/temp_user_db.dart';
import 'main.dart';
import 'routine_details_screen.dart';
import 'routine_screen.dart';

class EisenhowerMatrixScreen extends StatefulWidget {
  final Function(Routine) onRoutineUpdated;
  const EisenhowerMatrixScreen({super.key, required this.onRoutineUpdated});

  @override
  EisenhowerMatrixScreenState createState() => EisenhowerMatrixScreenState();
}

class EisenhowerMatrixScreenState extends State<EisenhowerMatrixScreen> {
  late Map<String, List<Routine>> technicalGroups;
  Map<String, List<Routine>> matrixQuadrants = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    var allRoutines = UserDatabase.getRoutines();
    for (var quadrant in [
      TextsInApp.getText("eisenhower_important_urgent"),
      TextsInApp.getText("eisenhower_important_not_urgent"),
      TextsInApp.getText("eisenhower_not_important_urgent"),
      TextsInApp.getText("eisenhower_not_important_not_urgent"),
    ]) {
      if (!matrixQuadrants.containsKey(quadrant)) {
        matrixQuadrants[quadrant] = [];
      }
    }

    for (var routine in allRoutines) {
      if (routine.isImportant == 1) {
        if (routine.isUrgent == 1) {
          matrixQuadrants[TextsInApp.getText("eisenhower_important_urgent")]!
              .add(routine);
        } else if (routine.isUrgent == 0) {
          matrixQuadrants[
                  TextsInApp.getText("eisenhower_important_not_urgent")]!
              .add(routine);
        }
      } else {
        if (routine.isUrgent == 1) {
          matrixQuadrants[
                  TextsInApp.getText("eisenhower_not_important_urgent")]!
              .add(routine);
        } else if (routine.isUrgent == 0) {
          matrixQuadrants[
                  TextsInApp.getText("eisenhower_not_important_not_urgent")]!
              .add(routine);
        }
      }
    }
    technicalGroups = _groupRoutinesByTechnique(allRoutines);
    setState(() {});
  }

  Map<String, List<Routine>> _groupRoutinesByTechnique(List<Routine> routines) {
    Map<String, List<Routine>> groups = {};

    final allocatedRoutineKeys = matrixQuadrants.values
        .expand((routines) => routines.map((routine) => routine.key))
        .toSet();
    for (var routine in routines) {
      if (allocatedRoutineKeys.contains(routine.key)) continue;

      if (!groups.containsKey(routine.workingTechnique)) {
        groups[routine.workingTechnique] = [];
      }
      groups[routine.workingTechnique]!.add(routine);
    }
    return groups;
  }

  void _moveRoutineToQuadrant(String quadrant, Routine routine) {
    setState(() {
      technicalGroups[routine.workingTechnique]?.remove(routine);
      if (!matrixQuadrants[quadrant]!.contains(routine)) {
        matrixQuadrants[quadrant]!.add(routine);
        routine.isImportant =
            (quadrant == TextsInApp.getText("eisenhower_important_urgent") ||
                    quadrant ==
                        TextsInApp.getText("eisenhower_important_not_urgent"))
                ? 1
                : 0;
        routine.isUrgent =
            (quadrant == TextsInApp.getText("eisenhower_important_urgent") ||
                    quadrant ==
                        TextsInApp.getText("eisenhower_not_important_urgent"))
                ? 1
                : 0;
      }
    });
  }

  void _moveRoutineBackToTechniqueGroup(String group, Routine routine) {
    setState(() {
      for (var routines in matrixQuadrants.values) {
        routines.remove(routine);
      }
      if (!technicalGroups.containsKey(group)) {
        technicalGroups[group] = [];
      }
      if (!technicalGroups[group]!.contains(routine)) {
        technicalGroups[group]!.add(routine);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: ValueListenableBuilder<double>(
          valueListenable: FontSizeNotifier.fontSizeNotifier,
          builder: (context, fontSize, child) {
            return Text(
              TextsInApp.getTechniqueNameWithLanguage(
                  Routine.eisenhowerIdentifier),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize + 4, // Slightly larger for emphasis
                color: Colors.white,
              ),
            );
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              ValueListenableBuilder<double>(
                valueListenable: FontSizeNotifier.fontSizeNotifier,
                builder: (context, fontSize, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      "-${TextsInApp.getText("eisenhower_technical_groups")}-",
                      style: TextStyle(
                        fontSize: fontSize + 4, // Dynamic font size
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  );
                },
              ),
              ...technicalGroups.entries.map((entry) => _buildTechnicalGroup(
                  entry.key, entry.value)), // Technical Groups

              ValueListenableBuilder<double>(
                valueListenable: FontSizeNotifier.fontSizeNotifier,
                builder: (context, fontSize, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      "-${TextsInApp.getText("eisenhower_matrix")}-",
                      style: TextStyle(
                        fontSize: fontSize + 4, // Dynamic font size
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  );
                },
              ),
              _buildEisenhowerMatrix(), // Matrix
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechnicalGroup(String technique, List<Routine> routines) {
    final isDarkMode = ThemeNotifier.themeNotifier.value == ThemeMode.dark;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor:
              Routine.getTechniqueColor(technique, isDarkMode).withOpacity(0.3),
          child: Icon(
            Routine.getTechniqueIcon(technique),
            color: Routine.getTechniqueColor(technique, isDarkMode)
                .withOpacity(0.4),
          ),
        ),
        title: ValueListenableBuilder<double>(
          valueListenable: FontSizeNotifier.fontSizeNotifier,
          builder: (context, fontSize, child) {
            return Text(
              technique,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontSize, // Dynamic font size
                color: Routine.getTechniqueColor(technique, isDarkMode),
              ),
            );
          },
        ),
        subtitle: ValueListenableBuilder<double>(
          valueListenable: FontSizeNotifier.fontSizeNotifier,
          builder: (context, fontSize, child) {
            return Text(
              "(${routines.length})",
              style: TextStyle(fontSize: fontSize - 2, color: Colors.grey),
            );
          },
        ),
        children: routines.map((routine) {
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
                ),
              );
            },
            style: ListTileStyle.list,
            /*tileColor: isDarkMode
                          ? Colors.deepPurple.shade900
                          : Colors.deepOrange.shade600,*/
            title: ValueListenableBuilder<double>(
              valueListenable: FontSizeNotifier.fontSizeNotifier,
              builder: (context, fontSize, child) {
                return Text(
                  routine.title,
                  style: TextStyle(
                      fontSize: fontSize, fontWeight: FontWeight.w500),
                );
              },
            ),
            subtitle: ValueListenableBuilder<double>(
              valueListenable: FontSizeNotifier.fontSizeNotifier,
              builder: (context, fontSize, child) {
                return Text(
                  "${TextsInApp.getText("scheduled")}: ${routine.dateTime.toLocal().toString().split(' ')[0]}",
                  style: TextStyle(fontSize: fontSize - 2, color: Colors.grey),
                );
              },
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.green),
              onPressed: () => _showMoveToQuadrantDialog(routine),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEisenhowerMatrix() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // Single column layout
        mainAxisSpacing: 10, // Spacing between groups
        crossAxisSpacing: 0, // No horizontal spacing
        mainAxisExtent: 260, // Set the height of each group explicitly
      ),
      itemCount: matrixQuadrants.length,
      itemBuilder: (context, index) {
        final title = matrixQuadrants.keys.elementAt(index);
        return _buildCompactQuadrant(title, matrixQuadrants[title]!);
      },
    );
  }

  Widget _buildCompactQuadrant(String title, List<Routine> routines) {
    final quadrantColors = {
      TextsInApp.getText("eisenhower_important_urgent"): Colors.redAccent,
      TextsInApp.getText("eisenhower_important_not_urgent"): Colors.green,
      TextsInApp.getText("eisenhower_not_important_urgent"):
          Colors.orangeAccent,
      TextsInApp.getText("eisenhower_not_important_not_urgent"):
          Colors.purpleAccent,
    };
    final color = quadrantColors[title] ?? Colors.grey;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Section
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.5),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            alignment: Alignment.center,
            child: ValueListenableBuilder<double>(
              valueListenable: FontSizeNotifier.fontSizeNotifier,
              builder: (context, fontSize, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize: fontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
          // List of Routines

          if (routines.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                physics: const BouncingScrollPhysics(),
                itemCount: routines.length,
                itemBuilder: (context, index) {
                  final routine = routines[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: ListTile(
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
                          ),
                        );
                      },
                      style: ListTileStyle.list,
                      /*tileColor: isDarkMode
                          ? Colors.deepPurple.shade900
                          : Colors.deepOrange.shade600,*/
                      title: ValueListenableBuilder<double>(
                        valueListenable: FontSizeNotifier.fontSizeNotifier,
                        builder: (context, fontSize, child) {
                          return Text(
                            routine.title,
                            style: TextStyle(
                              fontSize: fontSize - 1,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                      subtitle: ValueListenableBuilder<double>(
                        valueListenable: FontSizeNotifier.fontSizeNotifier,
                        builder: (context, fontSize, child) {
                          return Text(
                            "${TextsInApp.getText("scheduled")}: ${routine.dateTime.toLocal().toString().split(' ')[0]}",
                            style: TextStyle(
                              fontSize: fontSize - 2,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                      trailing: IconButton(
                        icon:
                            const Icon(Icons.arrow_back, color: Colors.orange),
                        onPressed: () => _moveRoutineBackToTechniqueGroup(
                            routine.workingTechnique, routine),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showMoveToQuadrantDialog(Routine routine) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            TextsInApp.getText("eisenhower_move_to_quadrant"),
            style: const TextStyle(fontSize: 16),
          ),
          children: matrixQuadrants.keys.map((quadrant) {
            return SimpleDialogOption(
              child: Text(
                quadrant,
                style: const TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.pop(context);
                _moveRoutineToQuadrant(quadrant, routine);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
