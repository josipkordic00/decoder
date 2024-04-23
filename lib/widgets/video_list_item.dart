import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    File? imageFile;

    void switchOnSingleLesson(BuildContext context, Course course) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (ctx) => SingleCourse(
                  course: course,
                )),
      );
    }

    Future<File> urlToFile(String imageUrl) async {
      final uri = Uri.parse(imageUrl);
      final response = await http.get(uri);

      final directory = await getApplicationDocumentsDirectory();
      final imagesDirectoryPath = '${directory.path}/user_profile_images';
      final imagesDirectory = Directory(imagesDirectoryPath);

      if (!await imagesDirectory.exists()) {
        await imagesDirectory.create(recursive: true);
      }

      final filePath =
          '${imagesDirectory.path}/${Uri.encodeComponent(uri.pathSegments.last)}';
      final file = File(filePath);
      //print("Saving file to: $filePath");

      await file.writeAsBytes(response.bodyBytes);

      return file;
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
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError) {
                  for (var doc in snapshot.data!.docs) {
                    if (doc.id == course.userId) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius:
                                    20, // The radius is half of both the width and height of the Container
                                backgroundImage:
                                    NetworkImage(doc.data()['image_url']),
                                backgroundColor: Colors
                                    .transparent, // Optional: set to transparent if needed
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  '${doc.data()['first_name']} ${doc.data()['last_name']}',
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
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
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
                                    '1234',
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
                    }
                  }
                }
                return const Text('Error');
              }),
        ),
      ),
    );
  }
}
