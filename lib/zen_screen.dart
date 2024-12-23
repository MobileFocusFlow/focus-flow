import 'package:flutter/material.dart';
import 'dart:async';
import 'package:focusflow/routine_screen.dart';
import 'components/language_select.dart';

class ZenScreen extends StatefulWidget {
  final Routine selectedRoutine;

  const ZenScreen({
    super.key,
    required this.selectedRoutine,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ZenScreenState createState() => _ZenScreenState();
}

class _ZenScreenState extends State<ZenScreen> {
  @override
  void initState() {
    super.initState();
    _timeRemaining = 0;
  }

  late int _timeRemaining;
  bool _isRunning = false;
  Timer? _timer;

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining < double.infinity) {
        setState(() {
          _timeRemaining++;
        });
      } else {
        timer.cancel();
        setState(() {
          _isRunning = false;
        });
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
      _timeRemaining = 0;
      _isRunning = false;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Zen Mode: ${widget.selectedRoutine.title}"),
        backgroundColor:
            Routine.getTechniqueColor(Routine.zenIdentifier, isDarkMode),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.selectedRoutine.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrangeAccent,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              _formatTime(_timeRemaining),
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
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
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow, size: 25),
                  label: Text(TextsInApp.getText("start")), //"Start"
                ),
                ElevatedButton.icon(
                  onPressed: _isRunning ? _pauseTimer : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.pause, size: 25),
                  label: Text(TextsInApp.getText("pause")), //"Pause"
                ),
                ElevatedButton.icon(
                  onPressed: _resetTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.replay, size: 25),
                  label: Text(TextsInApp.getText("reset")), //"Reset"
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
