import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Test {
  Test({
    required this.title,
    required this.position,
    required this.tasks,
    String? id,
  }) : id = id ?? uuid.v4();

  final String title;
  final List<dynamic> tasks;
  final int position;
  final String id;

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
      tasks: map['tasks'] as List<dynamic>,
      position: map['position'] as int,
    );
  }
}
