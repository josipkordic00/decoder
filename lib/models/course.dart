import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decoder/models/lesson.dart';

class Course {
  const Course(
      {required this.title,
      required this.lessons,
      this.image,
      required this.id,
      required this.userId,
      required this.tests,
      required this.enrolledUsers,
      required this.createdAt});
  final String title;
  final List<dynamic> lessons;
  final List<dynamic> tests;
  final List<dynamic> enrolledUsers;
  final String? image;
  final String id;
  final String userId;
  final Timestamp createdAt;

  factory Course.fromMap(
      Map<String, dynamic> map, String documentId, List<Lesson> lessons) {
    return Course(
      title: map['name'],
      lessons: lessons,
      id: documentId,
      enrolledUsers: List<String>.from(map['enrolled_users']),
      image: map['image_url'],
      userId: map['user_id'],
      createdAt: map['createdAt'],
      tests: List<String>.from(map['tests']),
    );
  }
}
