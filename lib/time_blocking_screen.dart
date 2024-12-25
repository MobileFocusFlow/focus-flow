import 'package:flutter/material.dart';
import 'package:focusflow/components/quote_manager.dart';
import 'dart:async';
import 'package:focusflow/routine_screen.dart';
import 'components/action_button.dart';
import 'components/language_select.dart';
import 'temp_user_db.dart';

class TimeBlockingScreen extends StatefulWidget {
  final Routine selectedRoutine;

  const TimeBlockingScreen({
    super.key,
    required this.selectedRoutine,
  });

  @override
  TimeBlockingScreenState createState() => TimeBlockingScreenState();
}

class TimeBlockingScreenState extends State<TimeBlockingScreen> {
  late int _timeRemaining;
  bool _isRunning = false;
  late String _motivationalQuote;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeRemaining = widget.selectedRoutine.workDuration * 60;
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
        _onBlockComplete();
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
      _timeRemaining = widget.selectedRoutine.workDuration * 60;
      _isRunning = false;
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double progress =
        (_timeRemaining / (widget.selectedRoutine.workDuration * 60));

    return Scaffold(
      appBar: AppDecorations.getTechniqueAppBar(widget.selectedRoutine.title,
          isDarkMode, Routine.timeBlockingIdentifier),
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
                    widget.selectedRoutine.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Routine.getTechniqueColor(
                              Routine.timeBlockingIdentifier, isDarkMode),
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
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Routine.getTechniqueColor(
                            Routine.timeBlockingIdentifier, isDarkMode)),
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
            "time_blocking_delete_routine_confirm") /*'You completed this time block. Do you want to delete this routine?'*/),
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
