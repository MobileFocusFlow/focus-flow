import 'dart:async';
import 'package:flutter/material.dart';
import 'package:focusflow/components/language_select.dart';
import 'package:focusflow/components/quote_manager.dart';
import 'components/action_button.dart';
import 'routine_screen.dart';
import 'temp_user_db.dart';

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
  String _currentPhase = TextsInApp.getText("work");
  late String _motivationalQuote;
  Timer? _timer;

  int get _workDuration => widget.selectedRoutine.workDuration * 60;
  int get _breakDuration => widget.selectedRoutine.breakDuration * 60;

  @override
  void initState() {
    super.initState();
    _timeRemaining = _workDuration;
    _motivationalQuote =
        QuoteManager.getRandomQuote(TextsInApp.getLanguageCode());
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
      _currentPhase = TextsInApp.getText("work");
    });
  }

  void _onIntervalComplete() {
    setState(() {
      if (_currentPhase == TextsInApp.getText("work")) {
        _pomodoroCount++;
        if (_pomodoroCount % 4 == 0) {
          _currentPhase = TextsInApp.getText("long_break");
          _timeRemaining = _breakDuration * 3;
          _onBlockComplete();
        } else {
          _currentPhase = TextsInApp.getText("break");
          _timeRemaining = _breakDuration;
        }
      } else {
        _currentPhase = TextsInApp.getText("work");
        _timeRemaining = _workDuration;
      }
      _motivationalQuote =
          QuoteManager.getRandomQuote(TextsInApp.getLanguageCode());
    });
  }

  void _onBlockComplete() {
    _showDeleteDialog(context, UserDatabase.lastSelectedRoutine.key);
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
    Color phaseColor = _currentPhase == TextsInApp.getText("work")
        ? Colors.green
        : (_currentPhase == TextsInApp.getText("long_break")
            ? Colors.blueAccent
            : Colors.orange);
    final double workProgress = _currentPhase == TextsInApp.getText("work")
        ? _computeProgress(_workDuration)
        : 0;
    final double breakProgress = _currentPhase != TextsInApp.getText("work")
        ? _computeProgress(_breakDuration)
        : 1;

    return Scaffold(
      appBar: AppDecorations.getTechniqueAppBar(
        widget.selectedRoutine.title,
        isDarkMode,
        Routine.pomodoroIdentifier,
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                          valueColor: AlwaysStoppedAnimation<
                              Color>(_currentPhase ==
                                  "${Text(TextsInApp.getText("long_break"))}"
                              ? Colors.blueAccent
                              : Colors.orange),
                        ),
                      ),
                      const SizedBox(width: 1),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: workProgress,
                          backgroundColor: Colors.grey[300],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppDecorations.getStartButtonForTimer(
                          _isRunning, _startTimer),
                      AppDecorations.getPauseButtonForTimer(
                          _isRunning, _pauseTimer),
                      AppDecorations.getResetButtonForTimer(_resetTimer),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0)
                  .copyWith(bottom: 16.0),
              child: QuoteManager.addQuoteContainer(
                  _motivationalQuote, context, _changeQuote),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String key) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(TextsInApp.getText(
            "routine_list_delete_routine") /*'Delete Routine'*/),
        content: Text(TextsInApp.getText(
            "pomodoro_delete_routine_confirm") /*'You completed this pomodoro. Do you want to delete this routine?'*/),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(TextsInApp.getText("cancel") /*'Cancel'*/),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                UserDatabase.removeRoutine(key);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RoutineScreen()),
                );
              });
            },
            child: Text(TextsInApp.getText("delete") /*'Delete'*/),
          ),
        ],
      ),
    );
  }
}
