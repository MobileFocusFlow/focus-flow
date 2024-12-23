import 'package:flutter/material.dart';
import 'package:focusflow/components/language_select.dart';
import 'package:focusflow/temp_user_db.dart';
import 'main.dart';
import 'routine_details_screen.dart';
import 'routine_screen.dart';

class EatThatFrogScreen extends StatefulWidget {
  final Function(Routine) onRoutineUpdated;
  const EatThatFrogScreen({
    super.key,
    required this.onRoutineUpdated,
  });

  @override
  EatThatFrogScreenState createState() => EatThatFrogScreenState();
}

class EatThatFrogScreenState extends State<EatThatFrogScreen> {
  late List<Routine> _sortedRoutines;

  @override
  void initState() {
    super.initState();
    _sortedRoutines = List.from(UserDatabase.getRoutines())
      ..sort((a, b) => b.priority.compareTo(a.priority));
  }

  void _updateDifficulty(Routine routine, int newDifficulty) {
    setState(() {
      routine.priority = newDifficulty;
      _sortedRoutines.sort((a, b) => b.priority.compareTo(a.priority));
    });
  }

  void _startTopDifficultyRoutine() {
    if (_sortedRoutines.isNotEmpty) {
      UserDatabase.lastSelectedRoutine = _sortedRoutines.first;
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No routines available to start.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Eat That Frog",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Routine.getTechniqueColor(
            Routine.eatThatFrogIdentifier, isDarkMode),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: ValueListenableBuilder<double>(
                valueListenable: FontSizeNotifier.fontSizeNotifier,
                builder: (context, fontSize, child) {
                  return ListView.builder(
                    itemCount: _sortedRoutines.length,
                    itemBuilder: (context, index) {
                      final routine = _sortedRoutines[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: Icon(
                            Routine.getTechniqueIcon(routine.workingTechnique),
                            color: Routine.getTechniqueColor(
                                routine.workingTechnique, isDarkMode),
                          ),
                          title: Text(
                            routine.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: fontSize,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                "Difficulty: ${routine.priority}",
                                style: TextStyle(fontSize: fontSize * 0.85),
                              ),
                              const SizedBox(width: 16),
                              ElevatedButton(
                                onPressed: () =>
                                    _showDifficultyDialog(context, routine),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                ),
                                child: const Text("Set Difficulty"),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward,
                              color: Colors.grey),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoutineDetailsScreen(
                                    onRoutinesUpdated: (updatedRoutine) {
                                  widget.onRoutineUpdated(updatedRoutine);
                                }),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 28),
            ValueListenableBuilder<double>(
              valueListenable: FontSizeNotifier.fontSizeNotifier,
              builder: (context, fontSize, child) {
                return ElevatedButton.icon(
                  onPressed: _startTopDifficultyRoutine,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Routine.getTechniqueColor(
                        Routine.eatThatFrogIdentifier, isDarkMode),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  icon: const Icon(
                    Icons.play_arrow,
                    size: 30,
                    color: Colors.white,
                  ),
                  label: Text(
                    TextsInApp.getText("start"),
                    style:
                        TextStyle(fontSize: fontSize + 4, color: Colors.white),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context, Routine routine) {
    final TextEditingController difficultyController =
        TextEditingController(text: routine.priority.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ValueListenableBuilder<double>(
          valueListenable: FontSizeNotifier.fontSizeNotifier,
          builder: (context, fontSize, child) {
            return AlertDialog(
              title: Text(
                "Set difficulty",
                style: TextStyle(fontSize: fontSize),
              ),
              content: TextField(
                controller: difficultyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter difficulty",
                  labelStyle: TextStyle(fontSize: fontSize * 0.85),
                  border: const OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: fontSize),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final int? newDifficulty =
                        int.tryParse(difficultyController.text);
                    if (newDifficulty != null) {
                      _updateDifficulty(routine, newDifficulty);
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
