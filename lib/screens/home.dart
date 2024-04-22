import 'package:decoder/providers/course_content.dart';
import 'package:decoder/screens/add_course.dart';
import 'package:decoder/screens/owned_courses.dart';
import 'package:decoder/screens/profile_statistics.dart';
import 'package:decoder/widgets/courses_list.dart';
import 'package:decoder/widgets/users_list.dart';
import 'package:decoder/widgets/video_list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:decoder/widgets/main_drawer.dart';
import 'package:decoder/providers/all_users.dart';
import 'package:decoder/data/dummydata.dart';
import 'package:decoder/widgets/custom_search_delegate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:decoder/providers/user_data.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser == null) {
      FirebaseAuth.instance.signOut();
    }
    final userId = FirebaseAuth.instance.currentUser!.uid;
    ref.read(userDataProvider.notifier).getFromFirestore(userId);
    ref.read(courseContentProvider.notifier).getAllCoursesFromFirestore();
    ref.read(allUsersProvider.notifier).getAllUsersFromFirestore();
    super.initState();
  }

  var _selectedBarIndex = 0;
  var _selectedBarTitle = 'Home';

  // when bottom bar is tapped
  void _changeIndex(int index) {
    setState(() {
      _selectedBarIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final prUser = ref.watch(userDataProvider);
    final courses = ref.watch(courseContentProvider);
    //default content on page
    Widget content = Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
      child: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return VideoListItem(course: courses[index]);
        },
      ),
    );

    //changing content based on tapped bottom bar
    if (_selectedBarIndex == 1) {
      //content = CoursesList(courses: courses);
      _selectedBarTitle = 'Courses';
    } else if (_selectedBarIndex == 2) {
      // content = UsersList(
      //   users: users,
      //  lessons: lessons,
      // );
      _selectedBarTitle = 'Instructors';
    } else {
      _selectedBarTitle = 'Home';
    }

    return prUser == null
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(_selectedBarTitle),
              actions: [
                IconButton(
                  onPressed: () {
                    //showSearch(context: context, delegate: CustomSearchDelegate());
                  },
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
            drawer: const MainDrawer(),
            body: content,
            floatingActionButton: prUser.role == "Student"
                ? null
                : InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const AddCourseScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(42),
                    child: const CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 70, 49, 128),
                      radius: 30,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: prUser.role == "Student"
                ? BottomNavigationBar(
                    onTap: _changeIndex,
                    currentIndex: _selectedBarIndex,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.play_circle_fill_rounded),
                        label: 'Active courses',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.supervised_user_circle),
                        label: 'Instructors',
                      ),
                    ],
                  )
                : BottomAppBar(
                    padding: const EdgeInsets.only(bottom: 1),
                    shape: const CircularNotchedRectangle(),
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.bar_chart_outlined,
                            color:
                                Theme.of(context).appBarTheme.foregroundColor,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) =>
                                    const OverallStatisticsScreen(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          padding: const EdgeInsets.only(left: 5),
                          icon: Icon(
                            Icons.playlist_play_rounded,
                            color:
                                Theme.of(context).appBarTheme.foregroundColor,
                            size: 30,
                          ),
                          onPressed: () {
                            ref
                                .read(courseContentProvider.notifier)
                                .getAllCoursesFromFirestore();
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (ctx) => const OwnedCoursesScreen(),
                            //   ),
                            // );
                          },
                        ),
                      ],
                    ),
                  ),
          );
  }
}
