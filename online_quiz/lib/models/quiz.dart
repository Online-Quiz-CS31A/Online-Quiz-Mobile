import 'quiz_result.dart';

class Quiz {
  final String id;
  final String title;
  final String courseId;
  final DateTime dueDate;
  final int totalQuestions;
  final int timeLimit; // in minutes
  final bool isCompleted;
  final QuizResult? result;
  Quiz({
    required this.id,
    required this.title,
    required this.courseId,
    required this.dueDate,
    required this.totalQuestions,
    required this.timeLimit,
    required this.isCompleted,
    this.result,
  });
}