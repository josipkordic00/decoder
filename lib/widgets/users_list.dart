import 'package:decoder/models/lesson.dart';
import 'package:decoder/models/user.dart';
import 'package:flutter/material.dart';

class UsersList extends StatelessWidget {
  const UsersList({super.key, required this.users, required this.lessons});

  final List<UserModel> users;
  final List<Lesson> lessons;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          //finding how much each user have courses
          
          //sort users by courses
          users.sort((a, b) => a.lastName.compareTo(b.lastName));

          return ListTile(
            onTap: () {},
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            title: Text(
              '${users[index].lastName} ${users[index].firstName}',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.bold),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          );
        });
  }
}
