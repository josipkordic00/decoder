import 'package:decoder/models/course.dart';
import 'package:decoder/models/lesson.dart';
import 'package:decoder/models/note.dart';
import 'package:decoder/models/test.dart';
import 'package:decoder/widgets/lesson_widget.dart';
import 'package:decoder/widgets/note_widget.dart';
import 'package:decoder/widgets/test_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CourseContentScreen extends StatefulWidget {
  const CourseContentScreen(
      {super.key,
      required this.course,
      required this.data,
      required this.allData});

  final Course course;
  final dynamic data;
  final List<dynamic> allData;

  @override
  State<CourseContentScreen> createState() => _CourseContentScreenState();
}

class _CourseContentScreenState extends State<CourseContentScreen> {
  var buttonPrevDisabled = false;
  var buttonNextDisabled = false;

  void nextLesson() {
    var position = widget.data['position'];
    if (position == 0) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => CourseContentScreen(
              course: widget.course,
              data: widget.allData[position],
              allData: widget.allData)));
    }
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => CourseContentScreen(
            course: widget.course,
            data: widget.allData[position + 1],
            allData: widget.allData)));
  }

  void prevLesson() {
    var position = widget.data['position'];
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (ctx) => CourseContentScreen(
            course: widget.course,
            data: widget.allData[position - 1],
            allData: widget.allData)));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data['position'] == 0) {
      buttonPrevDisabled = true;
    }
    if (widget.data['position'] == widget.allData.length - 1) {
      buttonNextDisabled = true;
    }
    Widget content = const Center(child: CircularProgressIndicator());

    if (widget.data.keys.contains('url')) {
      content = LessonWidget(
        lesson: Lesson(
            title: widget.data['title'],
            url: widget.data['url'],
            learned: widget.data['learned'],
            position: widget.data['position']),
        course: widget.course,
        lessonId: widget.data['id'],
      );
    } else if (widget.data.keys.contains('text')) {
      content = NoteWidget(
          note: Note(
              title: widget.data['title'],
              text: widget.data['text'],
              position: widget.data['position']),
          course: widget.course);
    } else {
      content = TestWidget(
          test: Test(
              title: widget.data['title'],
              position: widget.data['position'],
              tasks: widget.data['tasks']),
          course: widget.course);
    }
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: content),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buttonPrevDisabled
                  ? ElevatedButton.icon(
                      onPressed: () {},
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
                      ))
                  : ElevatedButton.icon(
                      onPressed: () {
                        prevLesson();
                      },
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
              buttonNextDisabled
                  ? ElevatedButton(
                      onPressed: () {},
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
                  : ElevatedButton(
                      onPressed: () {
                        nextLesson();
                      },
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
    );
  }
}
