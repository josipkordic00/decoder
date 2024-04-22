import 'package:decoder/models/course.dart';
import 'package:flutter/material.dart';
import 'package:decoder/data/dummydata.dart';

class SingleCourse extends StatefulWidget {
  const SingleCourse({super.key, required this.course});

  final Course course;
  @override
  State<SingleCourse> createState() {
    return _SingleCourseState();
  }
}

class _SingleCourseState extends State<SingleCourse> {
  var _selectedRowItem = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Hero(
              tag: widget.course.id,
              child: Image.network(
                widget.course.image!,
                height: 300,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: Row(
                children: [
                  InkWell(
                    splashColor: Theme.of(context).colorScheme.background,
                    highlightColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20),
                      child: Text(
                        'Lessons',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: _selectedRowItem
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedRowItem = true;
                      });
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    splashColor: Theme.of(context).colorScheme.background,
                    highlightColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withOpacity(0.2),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20),
                      child: Text(
                        'About',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: !_selectedRowItem
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedRowItem = false;
                      });
                    },
                  ),
                ],
              ),
            ),
            //listview.builder or about / based on selected row item
            _selectedRowItem
                ? Expanded(
                    child: ListView.builder(
                      itemCount: widget.course.lessons.length,
                      itemBuilder: (context, index) {
                        var data = widget.course.lessons;

                        return ListTile(
                          onTap: () {},
                          title: Text(
                            widget.course.lessons[index],
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          subtitle: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '3:10',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.done_all_sharp,
                            color: Color.fromARGB(255, 124, 157, 255),
                          ),
                        );
                      },
                    ),
                  )
                : Text(
                    'About course...',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
          ],
        ),
      ),
    );
  }
}
