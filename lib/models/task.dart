class TaskModel {
  const TaskModel({
    required this.question,
    required this.answers,
    required this.type,
    required this.correctAnswer
  });
 
  final String question;
  final List<String> answers;
  final String type;
  final String correctAnswer;

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answers': answers,
      'type': type,
      'correct_answer': correctAnswer
    };
  }

  factory TaskModel.fromMap(Map<dynamic, dynamic> map) {
    return TaskModel(
      question: map['question'] as String,
      answers: map['answers'] as List<String>,
      type: map['type'] as String,
      correctAnswer: map['correct_Answer'] as String
    );
  }
}
