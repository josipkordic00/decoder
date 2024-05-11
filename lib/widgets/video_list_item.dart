import 'package:decoder/models/course.dart';
import 'package:decoder/providers/user_data.dart';
import 'package:decoder/providers/all_users.dart';
import 'package:decoder/screens/single_course.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoListItem extends ConsumerStatefulWidget {
  const VideoListItem({super.key, required this.course});

  final Course course;

  @override
  ConsumerState<VideoListItem> createState() => _VideoListItemState();
}

class _VideoListItemState extends ConsumerState<VideoListItem> {
  void switchOnSingleLesson(BuildContext context, Course course) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (ctx) => SingleCourse(
                course: course,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseImage = ref.watch(courseImageProvider(widget.course.image!));
    final allUsers = ref.watch(allUsersProvider);

    final thisUser = allUsers.singleWhere(
      (element) => element['id'] == widget.course.userId,
      orElse: () =>
          {'first_name': 'User', 'last_name': 'Deleted', 'image': null},
    );


    return Card(
        margin: const EdgeInsets.only(bottom: 30),
        elevation: 2,
        child: InkWell(
          onTap: () {
            switchOnSingleLesson(context, widget.course);
          },
          splashColor: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      thisUser['image_url'] != null
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  FileImage(thisUser['image']),
                              backgroundColor: Colors.transparent,
                            )
                          : const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.transparent,
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          '${thisUser['first_name']} ${thisUser['last_name']}',
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
                    tag: widget.course.id,
                    child: Image(
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
                    widget.course.title,
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
                        'Lessons: ${widget.course.lessons.length}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                      Text(
                        'Tests: ${widget.course.tests.length}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                      Text(
                        'Notes: ${widget.course.notes.length}',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      Row(
                        children: [
                          Text(
                            '${widget.course.enrolledUsers.length}',
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
              ),
            ),
          ),
        ));
  }
}
