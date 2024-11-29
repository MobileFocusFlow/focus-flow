import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo.shade400,
          centerTitle: true,
          title: const Text("Focus Flow",
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
      ),
    );
  }
}
