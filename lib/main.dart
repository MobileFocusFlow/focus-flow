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
          backgroundColor: Colors.indigo.shade200,
          centerTitle: true,
          title: const Text("Focus Flow",
              style: TextStyle(fontSize: 22, color: Colors.white)),
        ),
      ),
    );
  }
}
