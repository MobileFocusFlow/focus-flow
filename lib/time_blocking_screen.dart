import 'package:flutter/material.dart';
import 'package:focusflow/components/quote_manager.dart';
import 'dart:async';
import 'package:focusflow/routine_screen.dart';

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
    UserDatabase.increaseRoutineCount(widget.selectedRoutine);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            TextsInApp.getText("time_block_complete")), //"Time Block Complete!"
        content: Text(TextsInApp.getText(
            "time_block_complete_message")), //"You've successfully completed this time block."
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
    Color phaseColor = Colors.deepOrangeAccent;
    final double progress =
        (_timeRemaining / (widget.selectedRoutine.workDuration * 60));

    return Scaffold(
      appBar: AppBar(
        title: Text("Time Blocking: ${widget.selectedRoutine.title}"),
        backgroundColor: Routine.getTechniqueColor(
            Routine.timeBlockingIdentifier, isDarkMode),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.selectedRoutine.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: phaseColor,
                  ),
              textAlign: TextAlign.center,
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
              valueColor: AlwaysStoppedAnimation<Color>(phaseColor),
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
                  label: Text(TextsInApp.getText("start") /*"Start"*/,
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
                  label: Text(TextsInApp.getText("pause") /*"Pause"*/,
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
                  label: Text(TextsInApp.getText("reset") /*"Reset"*/,
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
