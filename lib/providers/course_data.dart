import 'package:decoder/models/course.dart';
import 'package:decoder/models/lesson.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllCoursesNotifier extends StateNotifier<List<Course>> {
  AllCoursesNotifier() : super([]);

  void getAllCoursesFromFirestore() async {
    final coursesSnapshot =
        await FirebaseFirestore.instance.collection('courses').orderBy('createdAt', descending: true).get();

    List<Future<Course>> courseFutures = coursesSnapshot.docs.map((doc) async {
      List<Lesson> lessons = await _fetchLessonsForCourse(doc.id);
      return Course.fromMap(doc.data(), doc.id, lessons);
    }).toList();

    // Execute all futures in parallel and wait for them to complete
    List<Course> courses = await Future.wait(courseFutures);
    state = courses; // Update state once with all course data
  }


  Future<List<Lesson>> _fetchLessonsForCourse(String courseId) async {
    final lessonsSnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('lessons')
        .orderBy('createdAt', descending: false)
        .get();

    return lessonsSnapshot.docs
        .map((doc) => Lesson.fromMap(doc.data(), doc.id))
        .toList();
  }
}

final allCoursesProvider =
    StateNotifierProvider<AllCoursesNotifier, List<Course>>((ref) {
  return AllCoursesNotifier();
});


