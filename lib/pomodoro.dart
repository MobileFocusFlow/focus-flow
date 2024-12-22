import 'dart:async';
import 'package:flutter/material.dart';
import 'notification_service.dart';

class PomodoroScreen extends StatefulWidget {
  final String taskName;
  final int workDuration;
  final int breakDuration;

  const PomodoroScreen({
    super.key,
    required this.taskName,
    required this.workDuration,
    required this.breakDuration,
  });

  @override
  PomodoroScreenState createState() => PomodoroScreenState();
}

class PomodoroScreenState extends State<PomodoroScreen> {
  late int _timeRemaining;
  int _pomodoroCount = 0;
  bool _isRunning = false;
  String _currentPhase = "Work";

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeRemaining = widget.workDuration;
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        timer.cancel();
        _isRunning = false;
        _onIntervalComplete();
      }
    });
  }

  void _pauseTimer() {
    if (!_isRunning) return;

    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _timeRemaining = widget.workDuration;
      _isRunning = false;
      _currentPhase = "Work";
    });
  }

  void _onIntervalComplete() {
    setState(() {
      if (_currentPhase == "Work") {
        _pomodoroCount++;
        if (_pomodoroCount % 4 == 0) {
          _currentPhase = "Long Break";
          _timeRemaining = widget.breakDuration * 3;
        } else {
          _currentPhase = "Short Break";
          _timeRemaining = widget.breakDuration;
        }
        NotificationService().sendInstantNotification(
            "Time is Up", "You finished a Work session.");
      } else {
        _currentPhase = "Work";
        _timeRemaining = widget.workDuration;
        NotificationService().sendInstantNotification(
            "Time is Up", "You finished a Break session.");
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color phaseColor = _currentPhase == "Work"
        ? Colors.green
        : (_currentPhase == "Long Break" ? Colors.blueAccent : Colors.orange);

    return Scaffold(
      appBar: AppBar(
        title: Text("Pomodoro: ${widget.taskName}"),
        backgroundColor: phaseColor,
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentPhase,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: phaseColor,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              _formatTime(_timeRemaining),
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRunning ? null : _startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  icon: const Icon(Icons.play_arrow, size: 25),
                  label: const Text("Start", style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton.icon(
                  onPressed: _isRunning ? _pauseTimer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  icon: const Icon(Icons.pause, size: 25),
                  label: const Text("Pause", style: TextStyle(fontSize: 16)),
                ),
                ElevatedButton.icon(
                  onPressed: _resetTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  icon: const Icon(Icons.replay, size: 25),
                  label: const Text("Reset", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
