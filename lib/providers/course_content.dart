import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decoder/models/course.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseContentNotifier extends StateNotifier<List<Course>> {
  CourseContentNotifier() : super([]);

  void getAllCoursesFromFirestore() async {
    try {
      final usersSnapshot =
          await FirebaseFirestore.instance.collection('courses').get();

      for (var doc in usersSnapshot.docs) {
        var course = Course(
            title: doc.data()['name'],
            lessons: doc.data()['lessons'],
            id: doc.id,
            image: doc.data()['image_url'],
            userId: doc.data()['user_id'],
            tests: doc.data()['tests']);
        state = [...state, course];
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
}

final courseContentProvider =
    StateNotifierProvider<CourseContentNotifier, List<Course>>((ref) {
  return CourseContentNotifier();
});
