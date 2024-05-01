

class Course {
  const Course(
      {required this.title,
      required this.lessons,
      this.image,
      required this.id,
      required this.userId,
      required this.tests,
      required this.enrolledUsers
      });
  final String title;
  final List<dynamic> lessons;
  final List<dynamic> tests;
  final List<dynamic> enrolledUsers;
  final String? image;
  final String id;
  final String userId;
}
