class Task {
  const Task({
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

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      question: map['question'] as String,
      answers: map['answers'] as List<String>,
      type: map['type'] as String,
      correctAnswer: map['correct_answer'] as String
    );
  }
}
