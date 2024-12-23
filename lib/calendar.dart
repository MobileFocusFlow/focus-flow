import 'package:flutter/material.dart';
import 'package:focusflow/components/language_select.dart';
import 'package:focusflow/pomodoro_screen.dart';
import 'package:focusflow/task_batching_screen.dart';
import 'package:focusflow/time_blocking_screen.dart';
import 'package:focusflow/zen_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'routine_screen.dart';
import 'temp_user_db.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late Map<DateTime, List<Routine>> _events;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _events = _groupRoutinesByDate(UserDatabase.getRoutines());
  }

  Map<DateTime, List<Routine>> _groupRoutinesByDate(List<Routine> routines) {
    Map<DateTime, List<Routine>> events = {};
    for (var routine in routines) {
      final date = DateTime(
        routine.dateTime.year,
        routine.dateTime.month,
        routine.dateTime.day,
      );
      if (events[date] == null) {
        events[date] = [];
      }
      events[date]!.add(routine);
    }
    return events;
  }

  List<Routine> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TextsInApp.getText(
            "calendar_routine_calendar") /*'Task Calendar'*/),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildCalendar(),
          const SizedBox(height: 16.0),
          Expanded(
            child: _buildTaskList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _selectedDate,
          eventLoader: _getEventsForDay,
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.monday,
          selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
            });
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              shape: BoxShape.circle,
            ),
            markersMaxCount: 3,
            defaultTextStyle: Theme.of(context).textTheme.bodyMedium!,
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    final theme = Theme.of(context);
    final events = _getEventsForDay(_selectedDate);

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy,
                size: 80, color: theme.colorScheme.onSurface.withOpacity(0.6)),
            const SizedBox(height: 16),
            Text(
              TextsInApp.getText(
                  "calendar_no_routines_for_the_day") /*'No tasks for this day.'*/,
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final routine = events[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 4,
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _navigateToRoutineScreen(routine),
                ),
              );
            },
            leading: Icon(
              _getIconForTechnique(routine.workingTechnique),
              color: theme.colorScheme.primary,
            ),
            title: Text(
              routine.title,
              style: theme.textTheme.bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "${TextsInApp.getText("working_technique")}: ${routine.workingTechnique}\n${TextsInApp.getText("scheduled")}: ${routine.dateTime.hour}:${routine.dateTime.minute}:${routine.dateTime.second}\n${TextsInApp.getText("work_dur")}: ${routine.workDuration}",
              /*'Working Technique:Scheduled*/
              style: theme.textTheme.bodySmall,
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        );
      },
    );
  }

  Widget _navigateToRoutineScreen(Routine routine) {
    if (routine.workingTechnique == Routine.pomodoroIdentifier) {
      return PomodoroScreen(selectedRoutine: routine);
    } else if (routine.workingTechnique == Routine.timeBlockingIdentifier) {
      return TimeBlockingScreen(selectedRoutine: routine);
    } else if (routine.workingTechnique == Routine.zenIdentifier) {
      return ZenScreen(selectedRoutine: routine);
    }
    return TaskBatchingScreen();
  }

  IconData _getIconForTechnique(String technique) {
    if (technique == Routine.pomodoroIdentifier) {
      return Routine.pomodoroIcon;
    } else if (technique == Routine.timeBlockingIdentifier) {
      return Routine.timeBlockingIcon;
    } else if (technique == Routine.zenIdentifier) {
      return Routine.zenIcon;
    }
    return Routine.taskBatchingIcon;
  }
}
