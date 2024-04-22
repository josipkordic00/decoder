import 'dart:io';

import 'package:decoder/models/course.dart';
import 'package:decoder/models/lesson.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:decoder/screens/single_course.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:decoder/providers/all_users.dart';
import 'package:path_provider/path_provider.dart';
import 'package:transparent_image/transparent_image.dart';

class VideoListItem extends ConsumerWidget {
  const VideoListItem({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(allUsersProvider);
    var _firstName = '';
    var _lastName = '';
    var profileImage;

    for (var entry in data) {
      if (entry['id'] == course.userId) {
        _firstName = entry['first_name'];
        _lastName = entry['last_name'];
        profileImage = entry['image'];
      }
    }

    void switchOnSingleLesson(BuildContext context, Course course) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (ctx) => SingleCourse(
                  course: course,
                )),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 30),
      elevation: 2,
      child: InkWell(
        onTap: () {
          switchOnSingleLesson(context, course);
        },
        splashColor: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
            radius: 25,
            backgroundImage:
                profileImage != null ? FileImage(profileImage) : null,
            backgroundColor: Colors
                .transparent, // Show transparent background if image is null
          ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      '$_firstName $_lastName',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Hero(
                tag: course.id,
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(course.image!),
                  fit: BoxFit.fitHeight,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                course.title,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lessons: ${course.lessons.length}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  Text(
                    'Tests: ${course.tests.length}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Row(
                    children: [
                      Text(
                        '1234',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      const Icon(Icons.people_alt),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
