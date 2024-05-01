import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decoder/models/course.dart';
import 'package:decoder/models/lesson.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen(
      {super.key,
      required this.lesson,
      required this.course,
      required this.lessonId,
      required this.lessons,
      required this.index});

  final Lesson lesson;
  final Course course;
  final String lessonId;
  final List<dynamic> lessons;
  final int index;
  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
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

  void _nextLesson() {
    int nextIndex = widget.index + 1;
    Lesson dataLesson = Lesson(
        title: widget.lessons[nextIndex].title,
        url: widget.lessons[nextIndex].url,
        learned: widget.lessons[nextIndex].learned);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => LessonScreen(
            lesson: dataLesson,
            course: widget.course,
            lessonId: widget.lessons[nextIndex].id,
            lessons: widget.lessons,
            index: nextIndex)));
  }

  void _lastLesson() {
    int nextIndex = widget.index - 1;
    Lesson dataLesson = Lesson(
        title: widget.lessons[nextIndex].title,
        url: widget.lessons[nextIndex].url,
        learned: widget.lessons[nextIndex].learned);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => LessonScreen(
            lesson: dataLesson,
            course: widget.course,
            lessonId: widget.lessons[nextIndex].id,
            lessons: widget.lessons,
            index: nextIndex)));
  }

  void _updateLearned() async {
    var lessonDocRef = FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.course.id)
        .collection('lessons')
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.course.title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 8, left: 8, right: 8),
          child: Column(
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
                        Text('${widget.lesson.learned.length}' ,style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground),),
                      ],
                    ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                      onPressed: _lastLesson,
                      icon: Icon(
                        Icons.keyboard_double_arrow_left,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      label: Text(
                        'Last lesson',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                      )),
                  ElevatedButton(
                    onPressed: _nextLesson,
                    style: ElevatedButton.styleFrom(
                        maximumSize: const Size(200, 100)),
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Ensures the button size fits its content
                      children: <Widget>[
                        Text(
                          'Next lesson',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                        Icon(
                          Icons.keyboard_double_arrow_right,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
