import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:decoder/models/task.dart';

class Test {
  const Test(
      {required this.title,
      required this.id,
      required this.position,
      required this.tasks});
  final String title;
  final String id;
  final List<Task> tasks;
  final int position;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'tasks': tasks,
      'createdAt': Timestamp.now(),
      'position': position
    };
  }

  factory Test.fromMap(Map<String, dynamic> map, String documentId) {
    return Test(
      id: documentId,
      title: map['title'] as String,
      tasks: map['tasks'] as List<Task>,
      position: map['position'] as int,
    );
  }
}
