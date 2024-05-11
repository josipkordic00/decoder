
import 'package:decoder/models/course.dart';
import 'package:decoder/screens/add_course.dart';
import 'package:decoder/screens/owned_courses.dart';
import 'package:decoder/screens/profile_statistics.dart';
import 'package:decoder/providers/all_users.dart';
import 'package:decoder/providers/user_data.dart';
import 'package:decoder/providers/course_data.dart';
import 'package:decoder/widgets/custom_search_delegate.dart';
import 'package:decoder/widgets/courses_list.dart';
import 'package:decoder/widgets/main_drawer.dart';
import 'package:decoder/widgets/video_list_item.dart';
import 'package:decoder/widgets/user_profile.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> allCourses = [];
  List<Course> activeCourses = [];
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser == null) {
      FirebaseAuth.instance.signOut();
    }
    final userId = FirebaseAuth.instance.currentUser!.uid;
    ref.read(userDataProvider.notifier).getFromFirestore(userId);
 
    ref.read(allUsersProvider.notifier).getAllUsersFromFirestore();
    ref.read(allCoursesProvider.notifier).getAllCoursesFromFirestore();
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
    final allUsers = ref.watch(allUsersProvider);
    final List<Course> providerCourses = ref.watch(allCoursesProvider);

    //default content on page
    Widget content = Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('courses')
              .orderBy('createdAt', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            ref.read(allCoursesProvider.notifier).getAllCoursesFromFirestore();
            return ListView.builder(
              itemCount: providerCourses.length,
              itemBuilder: (context, index) {
                var course = Course(
                    title: providerCourses[index].title,
                    lessons: providerCourses[index].lessons,
                    notes: providerCourses[index].notes,
                    id: providerCourses[index].id,
                    enrolledUsers: providerCourses[index].enrolledUsers,
                    image: providerCourses[index].image,
                    userId: providerCourses[index].userId,
                    tests: providerCourses[index].tests,
                    createdAt: providerCourses[index].createdAt);
                return VideoListItem(course: course);
              },
            );
          }),
    );

    //changing content based on tapped bottom bar
    if (_selectedBarIndex == 1) {
      activeCourses = providerCourses
          .where((element) => element.enrolledUsers.contains(user!.uid))
          .toList();

      content = CoursesList(courses: activeCourses);
      _selectedBarTitle = 'Your courses';
    } else if (_selectedBarIndex == 2) {
      content = UserProfile(
        user: prUser!,
        userId: user!.uid,
      );
      _selectedBarTitle = 'Profile';
    } else {
      _selectedBarTitle = 'Home';
    }

    return prUser == null
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.hasError || !snapshot.hasData) {
                return const Scaffold(
                  body: Center(
                    child: Text('Error fetching data'),
                  ),
                );
              } else {
                if (snapshot.data!.data()!['role'] == "Student") {
                  return Scaffold(
                      appBar: AppBar(
                        title: Text(_selectedBarTitle),
                        actions: [
                          IconButton(
                            onPressed: () {
                              showSearch(
                                  context: context,
                                  delegate: CustomSearchDelegate(
                                      users: allUsers,
                                      courses: providerCourses));
                            },
                            icon: const Icon(Icons.search),
                          ),
                        ],
                      ),
                      drawer: const MainDrawer(),
                      body: content,
                      bottomNavigationBar: BottomNavigationBar(
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
                            icon: Icon(Icons.person_2_sharp),
                            label: 'Profile',
                          ),
                        ],
                      ));
                } else {
                  return Scaffold(
                      appBar: AppBar(
                        title: Text(_selectedBarTitle),
                        actions: [
                          IconButton(
                            onPressed: () {
                              showSearch(
                                  context: context,
                                  delegate: CustomSearchDelegate(
                                      users: allUsers,
                                      courses: providerCourses));
                            },
                            icon: const Icon(Icons.search),
                          )
                        ],
                      ),
                      drawer: const MainDrawer(),
                      body: content,
                      floatingActionButton: InkWell(
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
                      bottomNavigationBar: BottomAppBar(
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
                                color: Theme.of(context)
                                    .appBarTheme
                                    .foregroundColor,
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
                                color: Theme.of(context)
                                    .appBarTheme
                                    .foregroundColor,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        const OwnedCoursesScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ));
                }
              }
            });
  }
}
