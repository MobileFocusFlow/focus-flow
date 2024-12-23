import 'dart:async';
import 'package:flutter/material.dart';
import 'package:focusflow/components/language_select.dart';
import 'package:focusflow/temp_user_db.dart';
import 'package:focusflow/components/quote_manager.dart'; // Added for quotes
import 'routine_screen.dart';

class PomodoroScreen extends StatefulWidget {
  final Routine selectedRoutine;

  const PomodoroScreen({
    super.key,
    required this.selectedRoutine,
  });

  @override
  PomodoroScreenState createState() => PomodoroScreenState();
}

class PomodoroScreenState extends State<PomodoroScreen> {
  late int _timeRemaining;
  int _pomodoroCount = 0;
  bool _isRunning = false;
  String _currentPhase = "Work";
  late String _motivationalQuote;
  Timer? _timer;

  int get _workDuration => widget.selectedRoutine.workDuration * 60;
  int get _breakDuration => widget.selectedRoutine.breakDuration * 60;

  @override
  void initState() {
    super.initState();
    _timeRemaining = _workDuration;
    _motivationalQuote = QuoteManager.getRandomQuote(
        TextsInApp.getLanguageCode()); // Added for quotes
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
      _timeRemaining = _workDuration;
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
          _timeRemaining = _breakDuration * 3;
          _onBlockComplete();
        } else {
          _currentPhase = "Short Break";
          _timeRemaining = _breakDuration;
        }
      } else {
        _currentPhase = "Work";
        _timeRemaining = _workDuration;
      }
      _motivationalQuote =
          QuoteManager.getRandomQuote(TextsInApp.getLanguageCode());
    });
  }

  void _onBlockComplete() {
    UserDatabase.increaseRoutineCount(widget.selectedRoutine);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(TextsInApp.getText("pomodoro_complete")),
        content: Text(TextsInApp.getText("pomodoro_complete_message")),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _changeQuote() {
    setState(() {
      _motivationalQuote =
          QuoteManager.getRandomQuote(TextsInApp.getLanguageCode());
    });
  }

  double _computeProgress(int duration) {
    return _timeRemaining / duration;
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
    final double workProgress =
        _currentPhase == "Work" ? _computeProgress(_workDuration) : 0;
    final double breakProgress =
        _currentPhase != "Work" ? _computeProgress(_breakDuration) : 1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Pomodoro: ${widget.selectedRoutine.title}"),
        backgroundColor:
            Routine.getTechniqueColor(Routine.pomodoroIdentifier, isDarkMode),
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
            const SizedBox(height: 24),
            Text(
              _formatTime(_timeRemaining),
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: breakProgress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        _currentPhase == "Long Break"
                            ? Colors.blueAccent
                            : Colors.orange),
                  ),
                ),
                const SizedBox(width: 1),
                Expanded(
                  child: LinearProgressIndicator(
                    value: workProgress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              ],
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
                  label: Text(TextsInApp.getText("start"),
                      style: TextStyle(fontSize: 16)),
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
                  label: Text(TextsInApp.getText("pause"),
                      style: TextStyle(fontSize: 16)),
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
                  label: Text(TextsInApp.getText("reset"),
                      style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
            QuoteManager.addQuoteContainer(
                _motivationalQuote, context, _changeQuote),
          ],
        ),
      ),
    );
  }
}
