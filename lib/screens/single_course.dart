import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decoder/models/course.dart';
import 'package:decoder/models/lesson.dart';
import 'package:decoder/screens/lesson_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:decoder/providers/all_users.dart';

class SingleCourse extends ConsumerStatefulWidget {
  const SingleCourse({super.key, required this.course});

  final Course course;
  @override
  ConsumerState<SingleCourse> createState() {
    return _SingleCourseState();
  }
}

class _SingleCourseState extends ConsumerState<SingleCourse> {
  bool isEnrolled = false;
  bool onTapVideo = false;
  final Set<int> _tappedTiles = <int>{};
  final user = FirebaseAuth.instance.currentUser;
  var _selectedRowItem = true;
  var courseOwner = '';

  void _joinCourse() async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.course.id)
        .update({
          'enrolled_users': FieldValue.arrayUnion([user!.uid])
        })
        .then((_) => print("Course updated successfully."))
        .catchError((error) => print("Error updating course: $error"));
    setState(() {
      isEnrolled = true;
    });
  }

  @override
  void initState() {
    if (widget.course.enrolledUsers.contains(user!.uid)) {
      isEnrolled = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allUsers = ref.watch(allUsersProvider);
    final courseOwner = allUsers.singleWhere(
      (e) => e['id'] == widget.course.id,
      orElse: () =>
          {'first_name': 'User', 'last_name': 'Deleted', 'image_url': null},
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Hero(
                tag: widget.course.id,
                child: Image.network(
                  widget.course.image!,
                  height: 300,
                  width: double.infinity,
                ),
              ),
            ),
            isEnrolled
                ? Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: _selectedRowItem
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onBackground,
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                      color: !_selectedRowItem
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onBackground,
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
                  )
                : const SizedBox(
                    height: 40,
                  ),
            isEnrolled
                ?
                //listview.builder or about / based on selected row item
                _selectedRowItem
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: widget.course.lessons.length,
                          itemBuilder: (context, index) {
                            bool isTapped = _tappedTiles.contains(index);
                            var data = widget.course.lessons;

                            return ListTile(
                                onTap: () {
                                  Lesson dataLesson = Lesson(
                                      title: data[index].title,
                                      url: data[index].url,
                                      learned: data[index].learned);

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => LessonScreen(
                                            lesson: dataLesson,
                                            course: widget.course,
                                            lessonId: data[index].id,
                                            index: index,
                                            lessons: data,
                                          )));
                                },
                                leading: Icon(
                                  Icons.ondemand_video_rounded,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                                title: Text(
                                  data[index].title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                ),
                                tileColor: isTapped
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.1)
                                    : null,
                                trailing: StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('courses')
                                        .doc(widget.course.id)
                                        .collection('lessons')
                                        .doc(data[index]
                                            .id) // Ensure this document ID is correct
                                        .snapshots(),
                                    builder: (ctx,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data!.exists) {
                                        // Access the document data directly
                                        var lessonData = snapshot.data!.data()
                                            as Map<String, dynamic>;
                                        List<dynamic> learnedUsers =
                                            lessonData['learned'];
                                        if (learnedUsers.contains(user!.uid)) {
                                          return const Icon(
                                              Icons.done_all_sharp,
                                              color: Color.fromARGB(
                                                  255, 124, 157, 255));
                                        } else {
                                          return Icon(Icons.done_all_sharp,
                                              color: Theme.of(ctx)
                                                  .colorScheme
                                                  .onBackground);
                                        }
                                      } else if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else if (!snapshot.hasData) {
                                        return const Text('No data');
                                      } else {
                                        // Default fallback for waiting state
                                        return const CircularProgressIndicator();
                                      }
                                    }));
                          },
                        ),
                      )
                    : Text(
                        'About course...',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                      )
                : Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            widget.course.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${courseOwner['first_name']} ${courseOwner['last_name']}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          ElevatedButton.icon(
                              onPressed: _joinCourse,
                              icon: Icon(
                                Icons.add_circle,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              label: Text(
                                'Join course',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                              )),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
