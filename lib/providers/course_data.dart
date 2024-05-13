import 'package:decoder/models/course.dart';
import 'package:decoder/models/lesson.dart';
import 'package:decoder/models/note.dart';
import 'package:decoder/models/test.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllCoursesNotifier extends StateNotifier<List<Course>> {
  AllCoursesNotifier() : super([]);

  void getAllCoursesFromFirestore() async {
  
    final coursesSnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .orderBy('createdAt', descending: true)
        .get();

    List<Future<Course>> courseFutures = coursesSnapshot.docs.map((doc) async {
      List<dynamic> content = await _fetchContentForCourse(doc.id);
      return Course.fromMap(doc.data(), doc.id, content);
    }).toList();

    // Execute all futures in parallel and wait for them to complete
    List<Course> courses = await Future.wait(courseFutures);
    state = courses; // Update state once with all course data
  }

  Future<List<dynamic>> _fetchContentForCourse(String courseId) async {
 
    List<dynamic> docs = [];

    final contentSnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc(courseId)
        .collection('content')
        .orderBy('position', descending: false)
        .get();
    for (var doc in contentSnapshot.docs) {
      docs.add(doc.data());
    }
    return docs;
  }
}

final allCoursesProvider =
    StateNotifierProvider<AllCoursesNotifier, List<Course>>((ref) {
  return AllCoursesNotifier();
});
