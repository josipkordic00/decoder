import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decoder/models/course.dart';
import 'package:flutter/material.dart';
import 'package:decoder/screens/single_course.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:decoder/providers/user_data.dart';

class VideoListItem extends ConsumerWidget {
  const VideoListItem({super.key, required this.course});

  final Course course;
  void switchOnSingleLesson(BuildContext context, Course course) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (ctx) => SingleCourse(
                course: course,
              )),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSnapshot = ref.watch(userDataProvider2(course.userId));
    final courseImage = ref.watch(courseImageProvider(course.image!));

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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: userSnapshot.when(
                data: (doc) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(doc['image_url']),
                            backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              '${doc['first_name']} ${doc['last_name']}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
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
                          image: courseImage,
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          Text(
                            'Tests: ${course.tests.length}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          Row(
                            children: [
                              Text(
                                '${course.enrolledUsers.length}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
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
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
            ),
          ),
        ));
  }
}
