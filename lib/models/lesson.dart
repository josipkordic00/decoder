import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Lesson {
  Lesson({
    required this.title,
    required this.url,
    required this.learned,
    String? id,
  }) : id = id ?? uuid.v4();

  final String title;
  final String url;
  final String id;
  final List<dynamic> learned;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'learned': learned,
      'createdAt': Timestamp.now()
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map, String documentId) {
    return Lesson(
      id: documentId,
      title: map['title'] as String,
      url: map['url'] as String,
      learned: map['learned'] as List<dynamic>,
    );
  }
}
