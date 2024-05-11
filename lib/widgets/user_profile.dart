import 'package:decoder/models/user.dart';
import 'package:decoder/providers/course_data.dart';
import 'package:decoder/screens/single_course.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key, required this.user, required this.userId});

  final UserModel user;
  final String userId;

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(allCoursesProvider);
    final userCourses =
        courses.where((e) => e.enrolledUsers.contains(widget.userId)).toList();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          children: [
            Text(
              widget.user.role,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              backgroundImage: FileImage(widget.user.image!),
              radius: 50,
            ),
            const SizedBox(height: 20),
            Text(
              '${widget.user.firstName} ${widget.user.lastName}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.user.email,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(height: 55),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Active courses',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: userCourses.length,
                itemBuilder: (context, index) {
                  final course = userCourses[index];
                  // Fetch course user info if needed
                  return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => SingleCourse(course: course)));
                        },
                        leading: Icon(Icons.play_lesson_sharp,
                            color: Theme.of(context).colorScheme.onBackground),
                        title: Text(
                          course.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        subtitle: course.userId == widget.userId
                            ? Text(
                                'Owned',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              )
                            : Text(
                                'Participant',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                              ),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
