import 'package:decoder/models/lesson.dart';
import 'package:decoder/models/test.dart';
import 'package:decoder/models/user.dart';

class Course {
  const Course(
      {required this.title,
      required this.lessons,
      this.image,
      required this.id,
      required this.userId,
      required this.tests});
  final String title;
  final List<dynamic> lessons;
  final List<dynamic> tests;
  final String? image;
  final String id;
  final String userId;
}
