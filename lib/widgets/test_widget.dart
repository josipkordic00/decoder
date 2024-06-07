import 'package:decoder/models/test.dart';
import 'package:flutter/material.dart';
import 'package:decoder/models/course.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({super.key, required this.test, required this.course});

  final Test test;
  final Course course;

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  var currentIndex = 0;
  var answered = false;
  void _checkAnswer(String ans) {
    if (widget.test.tasks[currentIndex]['correct_Answer'] == ans) {
      print('da');
    } else {
      print('ne');
    }
    setState(() {
      answered = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text('data');
    var tasksLength = widget.test.tasks.length;
    var question = widget.test.tasks[currentIndex]['question'];
    var type = widget.test.tasks[currentIndex]['type'];
    List<dynamic> answers = widget.test.tasks[currentIndex]['answers'];

    if (type == "True/false") {
      content = Column(
        children: [
          ListTile(
            title: Text('True'),
            onTap: () {
              _checkAnswer('True');
            },
            leading: answered
                    ? 'True' ==
                            widget.test.tasks[currentIndex]['correct_Answer']
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.tertiary,
                          )
                        : Icon(Icons.close,
                            color: Theme.of(context).colorScheme.error)
                    : null
          ),
          ListTile(
            title: Text('False'),
            onTap: () {
              _checkAnswer('False');
            },
            leading: answered
                    ? 'False' ==
                            widget.test.tasks[currentIndex]['correct_Answer']
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.tertiary,
                          )
                        : Icon(Icons.close,
                            color: Theme.of(context).colorScheme.error)
                    : null
          )
        ],
      );
    } else if (type == "Multiple choice") {
      content = Expanded(
        child: ListView.builder(
          itemCount: answers.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                title: Text(answers[index]),
                onTap: () {
                  _checkAnswer(answers[index]);
                },
                leading: answered
                    ? answers[index] ==
                            widget.test.tasks[currentIndex]['correct_Answer']
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.tertiary,
                          )
                        : Icon(Icons.close,
                            color: Theme.of(context).colorScheme.error)
                    : null);
          },
        ),
      );
    } else {
      content = Expanded(
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
          decoration: const InputDecoration(
            labelText: 'Your answer',
            border: OutlineInputBorder(),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Question: $question', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onBackground),),
            content,
            ElevatedButton(
                onPressed: () {
                  if (currentIndex < tasksLength - 1) {
                    setState(() {
                      answered = false;
                      currentIndex++;
                    });
                  }
                },
                child: Text('next')),
            ElevatedButton(
                onPressed: () {
                  if (currentIndex > 0) {
                    setState(() {
                      currentIndex--;
                      answered = false;
                    });
                  }
                },
                child: Text('prev')),
          ],
        ),
      ),
    );
  }
}
