import 'package:decoder/models/course.dart';
import 'package:decoder/models/lesson.dart';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonWidget extends StatefulWidget {
  const LessonWidget({
    super.key,
    required this.lesson,
    required this.course,
    required this.lessonId,
  });

  final Lesson lesson;
  final Course course;
  final String lessonId;

  @override
  State<LessonWidget> createState() => _LessonWidgetState();
}

class _LessonWidgetState extends State<LessonWidget> {
  late YoutubePlayerController _controller;
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.lesson.url,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    super.initState();
  }

  void _updateLearned() async {
    var lessonDocRef = FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.course.id)
        .collection('content')
        .doc(widget.lessonId);
    await lessonDocRef
        .update({
          'learned': FieldValue.arrayUnion([user!.uid])
        })
        .then((_) => print("Lesson updated successfully."))
        .catchError((error) => print("Error updating lesson: $error"));
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          onEnded: (metaData) {
            _updateLearned();
            Navigator.of(context).pop();
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.lesson.title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'Viewers: ',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('courses')
                      .doc(widget.course.id)
                      .collection('content')
                      .doc(widget.lessonId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.hasError) {
                      return Text(
                        'Error',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        'Loading ...',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                      );
                    }
                    return Text(
                      '${snapshot.data!.data()!['learned'].length}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    );
                  }),
            ],
          ),
        ),
      ],
    );
    return content;
  }
}
