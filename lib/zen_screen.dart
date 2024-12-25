import 'package:flutter/material.dart';
import 'dart:async';
import 'package:focusflow/routine_screen.dart';
import 'components/action_button.dart';
import 'components/language_select.dart';
import 'components/quote_manager.dart';

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
  late String _motivationalQuote;
  @override
  void initState() {
    super.initState();
    _timeRemaining = 0;
    _motivationalQuote =
        QuoteManager.getRandomQuote(TextsInApp.getLanguageCode());
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
      appBar: AppDecorations.getTechniqueAppBar(
          widget.selectedRoutine.title, isDarkMode, Routine.zenIdentifier),
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
                              Routine.zenIdentifier, isDarkMode),
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

  void _changeQuote() {
    setState(() {
      _motivationalQuote =
          QuoteManager.getRandomQuote(TextsInApp.getLanguageCode());
    });
  }
}
