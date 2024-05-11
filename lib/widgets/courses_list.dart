import 'package:decoder/models/course.dart';
import 'package:decoder/screens/single_course.dart';
import 'package:decoder/providers/all_users.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoursesList extends ConsumerStatefulWidget {
  const CoursesList({super.key, required this.courses});

  final List<Course> courses;

  @override
  _CoursesListState createState() => _CoursesListState();
}

class _CoursesListState extends ConsumerState<CoursesList> {
  late List<Future<QuerySnapshot>> lessonFutures;
  Map<String, String> userNames = {};

  @override
  void initState() {
    super.initState();
    lessonFutures = widget.courses.map((course) {
      var courseRef =
          FirebaseFirestore.instance.collection('courses').doc(course.id);
      return courseRef
          .collection('lessons')
          .orderBy('createdAt', descending: false)
          .get();
    }).toList();
    _fetchUserNames();
  }

  Future<void> _fetchUserNames() async {
    final users = ref.read(allUsersProvider);
    for (var user in users) {
      userNames[user['id']] = '${user['first_name']} ${user['last_name']}';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.courses.length,
      itemBuilder: (context, index) {
        var courseUser =
            userNames[widget.courses[index].userId] ?? 'User Deleted';

        return ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => SingleCourse(course: widget.courses[index])));
          },
          leading: Icon(
            Icons.code,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          title: Text(
            widget.courses[index].title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            courseUser,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.primary.withBlue(200)),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        );
      },
    );
  }
}
