import 'package:flutter/material.dart';
import 'routine_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RoutineScreen()),
              );
            },
            child: const Text('Go to Routine Screen'),
          ),
        ],
      )),
    );
  }
}
