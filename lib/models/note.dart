import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Note {
  Note({
    required this.title,
    required this.text,
    String? id,
    required this.position
  }) : id = id ?? uuid.v4();

  final String title;
  final String text;
  final String id;
  final int position;
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'position': position,
      'createdAt': Timestamp.now()
    };
  }

  factory Note.fromMap(Map<String, dynamic> map, String documentId) {
    return Note(
      id: documentId,
      title: map['title'] as String,
      text: map['text'] as String,
      position: map['position'] as int,
    );
  }
}
