import 'quiz.dart';

class Course {
  final String id;
  final String name;
  final String code;
  final List<Quiz> quizzes;
  final String instructor;
  final int units;

  Course({
    required this.id,
    required this.name,
    required this.code,
    required this.quizzes,
    required this.instructor,
    required this.units,
  });
}