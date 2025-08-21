class QuizResult {
  final String id;
  final String quizId;
  final int correctAnswers;
  final int totalQuestions;
  final DateTime completedAt;
  final int timeSpent; // in minutes
  final List<QuestionResult> questionResults;

  QuizResult({
    required this.id,
    required this.quizId,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.completedAt,
    required this.timeSpent,
    required this.questionResults,
  });

  double get percentage => (correctAnswers / totalQuestions) * 100;
}

class QuestionResult {
  final String questionId;
  final String question;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;

  QuestionResult({
    required this.questionId,
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });
}