import 'package:flutter/material.dart';
import 'package:focusflow/components/language_select.dart';

import '../temp_user_db.dart';

class PostItNote extends StatefulWidget {
  final Function(String) onSave;

  const PostItNote({super.key, required this.onSave});

  @override
  // ignore: library_private_types_in_public_api
  _PostItNoteState createState() => _PostItNoteState();
}

class _PostItNoteState extends State<PostItNote> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: UserDatabase.lastSelectedRoutine.postItNote);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        width: screenWidth * 0.85, // 85% of the screen width
        height: 280,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.yellow[200],
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: TextField(
                  controller: _controller,
                  maxLines: null, // Allows wrapping of text
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: TextsInApp.getText(
                        "post_it_hint_text"), //'Write something...'
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  widget.onSave(_controller.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(TextsInApp.getText("post_it_saved"))),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: Text(TextsInApp.getText("save")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
