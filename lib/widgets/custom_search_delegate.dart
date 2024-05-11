import 'package:decoder/models/course.dart';
import 'package:decoder/models/user.dart';
import 'package:decoder/screens/single_course.dart';
import 'package:decoder/widgets/user_profile.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserTitle extends StatelessWidget {
  const UserTitle(
      {super.key, required this.title, required this.id, required this.email});
  final String title;
  final String id;
  final String email;
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<Map<String, dynamic>> users;

  List<Course> courses;
  CustomSearchDelegate({required this.users, required this.courses}) {
    users = List<Map<String, dynamic>>.from(users);
    courses = List<Course>.from(courses);
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      inputDecorationTheme: const InputDecorationTheme(
        outlineBorder: BorderSide.none,
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
      textTheme: GoogleFonts.montserratTextTheme(
        Theme.of(context).textTheme.merge(
              TextTheme(
                titleLarge: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(
          Icons.clear,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onBackground,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<List<dynamic>> matchQuery = [];
    //making list type of[model, icon, string] for users
    for (var i in users) {
      //map users name into course model title for easier applying in search
      String concat = '${i['first_name']} ${i['last_name']}';
      if (concat.toLowerCase().contains(query.toLowerCase())) {
        
        matchQuery.add([
          UserTitle(
            title: concat,
            id: i['id'],
            email: i['email'],
          ),
          Icon(
            Icons.account_circle,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          'User'
        ]);
      }
    }

    //making list type of[model, icon, string] for courses
    for (var i in courses) {
      if (i.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add([
          i,
          Icon(
            Icons.book,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          'Course'
        ]);
      }
    }

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Theme.of(context).colorScheme.background,
        Theme.of(context).appBarTheme.backgroundColor!
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: ListView.builder(
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            //result = current index in list[widget, icon, string]
            var result = matchQuery[index];
            return ListTile(
              onTap: () {
                if (result[2] == 'User') {
                  var userData =
                      users.singleWhere((e) => e['id'] == result[0].id);
                  UserModel user = UserModel(
                      firstName: userData['first_name'],
                      lastName: userData['last_name'],
                      email: userData['email'],
                      image: userData['image'],
                      role: userData['role']);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) =>
                          UserProfile(user: user, userId: userData['id'])));
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => SingleCourse(course: result[0])));
                }
              },
              leading: result[1],
              title: Text(
                result[0].title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                result[2] == 'User'
                    ? result[0].email
                    : 'Enrolled users ${result[0].enrolledUsers.length}',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            );
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<List<dynamic>> matchQuery = [];
    //making list type of[model, icon, string] for users
    for (var i in users) {
      //map users name into course model title for easier applying in search
      String concat = '${i['first_name']} ${i['last_name']}';
      if (concat.toLowerCase().contains(query.toLowerCase())) {
        
        matchQuery.add([
          UserTitle(
            title: concat,
            id: i['id'],
            email: i['email'],
          ),
          Icon(
            Icons.account_circle,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          'User'
        ]);
      }
    }

    //making list type of[model, icon, string] for courses
    for (var i in courses) {
      if (i.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add([
          i,
          Icon(
            Icons.book,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          'Course'
        ]);
      }
    }

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Theme.of(context).colorScheme.background,
        Theme.of(context).appBarTheme.backgroundColor!
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: ListView.builder(
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            //result = current index in list[widget, icon, string]
            var result = matchQuery[index];
            return ListTile(
              onTap: () {
                if (result[2] == 'User') {
                  var userData =
                      users.singleWhere((e) => e['id'] == result[0].id);
                  UserModel user = UserModel(
                      firstName: userData['first_name'],
                      lastName: userData['last_name'],
                      email: userData['email'],
                      image: userData['image'],
                      role: userData['role']);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) =>
                          UserProfile(user: user, userId: userData['id'])));
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => SingleCourse(course: result[0])));
                }
              },
              leading: result[1],
              title: Text(
                result[0].title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                result[2] == 'User'
                    ? result[0].email
                    : 'Enrolled users ${result[0].enrolledUsers.length}',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            );
          }),
    );
  }
}
