import 'package:flutter/material.dart';

class LessonSection extends StatelessWidget {
  const LessonSection({super.key, required this.title, required this.videoID});

  final String title;
  final String videoID;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      borderRadius: BorderRadius.circular(15),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(bottom: 10),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.secondaryContainer,
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ListTile(
            leading: Icon(
              Icons.ondemand_video_rounded,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ),
        ),
      ),
    );
  }
}
