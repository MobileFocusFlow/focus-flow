import 'dart:async';
import 'package:flutter/material.dart';

class PomodoroScreen extends StatefulWidget {
  final String taskName;
  final int workDuration; // User-selected work duration in seconds
  final int breakDuration; // User-selected break duration in seconds

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
    _timeRemaining =
        widget.workDuration; // Set initial time based on user input
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
      _timeRemaining =
          widget.workDuration; // Reset to the user selected work duration
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
          _timeRemaining =
              widget.breakDuration * 3; // Set to longer break after 4 cycles
        } else {
          _currentPhase = "Short Break";
          _timeRemaining = widget.breakDuration;
        }
      } else {
        _currentPhase = "Work";
        _timeRemaining = widget.workDuration;
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
    return Scaffold(
      appBar: AppBar(title: Text("Pomodoro: ${widget.taskName}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _currentPhase,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              _formatTime(_timeRemaining),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _startTimer,
                  child: const Text("Start"),
                ),
                ElevatedButton(
                  onPressed: _isRunning ? _pauseTimer : null,
                  child: const Text("Pause"),
                ),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: const Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
