import 'package:flutter/material.dart';
import 'package:decoder/models/course.dart';
import 'package:decoder/models/note.dart';

class NoteWidget extends StatelessWidget {
  const NoteWidget({super.key, required this.note, required this.course});

  final Note note;
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              note.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 24, // Adjusted font size for better readability
                    fontWeight: FontWeight.bold,
                    
                  ),
            ),
          
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                note.text,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
          ],
        ),
      
    );
  }
}
