import 'package:cloud_firestore/cloud_firestore.dart';


class Course {
  const Course(
      {required this.title,
      required this.content,
      this.image,
      required this.id,
      required this.userId,
      required this.enrolledUsers,
      required this.createdAt});
  final String title;
  final List<dynamic> content;
  final List<dynamic> enrolledUsers;
  final String? image;
  final String id;
  final String userId;
  final Timestamp createdAt;

  factory Course.fromMap(
      Map<String, dynamic> map, String documentId, List<dynamic> content,) {
    return Course(
      title: map['name'],
      content: content,
      id: documentId,
      enrolledUsers: List<String>.from(map['enrolled_users']),
      image: map['image_url'],
      userId: map['user_id'],
      createdAt: map['createdAt'],
    );
  }
}
