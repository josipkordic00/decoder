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
  final bool learned;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'learned': learned,
    };
  }
}
