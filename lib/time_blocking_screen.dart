import 'package:flutter/material.dart';
import 'dart:async';

class TimeBlockingScreen extends StatefulWidget {
  final String taskName;
  final int blockDuration;

  const TimeBlockingScreen({
    super.key,
    required this.taskName,
    required this.blockDuration,
  });

  @override
  TimeBlockingScreenState createState() => TimeBlockingScreenState();
}

class TimeBlockingScreenState extends State<TimeBlockingScreen> {
  late int _timeRemaining;
  bool _isRunning = false;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeRemaining = widget.blockDuration;
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
      _timeRemaining = widget.blockDuration;
      _isRunning = false;
    });
  }

  void _onBlockComplete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Time Block Complete!"),
        content: const Text("You've successfully completed this time block."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
    Color phaseColor = Colors.deepOrangeAccent;

    return Scaffold(
      appBar: AppBar(
        title: Text("Time Blocking: ${widget.taskName}"),
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
              widget.taskName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: phaseColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
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
