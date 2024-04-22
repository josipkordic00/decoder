import 'package:decoder/models/course.dart';
import 'package:flutter/material.dart';

class CoursesList extends StatelessWidget {
  const CoursesList({super.key, required this.courses});

  final List<Course> courses;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: (){},
            leading: Icon(Icons.code, color: Theme.of(context).colorScheme.onBackground,),
            title: Text(
              courses[index].title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground, fontWeight: FontWeight.bold),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          );
        });
  }
}
