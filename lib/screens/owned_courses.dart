import 'package:decoder/providers/course_data.dart';
import 'package:decoder/screens/single_course.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OwnedCoursesScreen extends ConsumerStatefulWidget {
  const OwnedCoursesScreen({super.key});

  @override
  ConsumerState<OwnedCoursesScreen> createState() => _OwnedCoursesScreenState();
}

class _OwnedCoursesScreenState extends ConsumerState<OwnedCoursesScreen> {
  final user = FirebaseAuth.instance.currentUser;
  String _formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    var formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final providerCourses = ref.watch(allCoursesProvider);

    final userCourses = providerCourses.where(
      (element) => element.userId == user!.uid,
    ).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Owned courses')),
      body: ListView.builder(
        itemCount: userCourses.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => SingleCourse(course: userCourses[index])));
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0), // Rounded corners
              ),
              title: Text(userCourses[index].title,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              subtitle: Text(
                  'Created at ${_formatDate(userCourses[index].createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      )),
              trailing: Text(
                  'Users ${userCourses[index].enrolledUsers.length}',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      )),
            ),
          );
        },
      ),
    );
  }
}
