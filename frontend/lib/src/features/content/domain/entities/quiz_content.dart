import 'package:equatable/equatable.dart';

class QuizContent extends Equatable {
  final String id;
  final String chapterId;
  final List<QuizQuestionEntity> questions;
  final String title;
  final int timeLimit; // in seconds
  final DateTime createdAt;

  const QuizContent({
    required this.id,
    required this.chapterId,
    required this.questions,
    required this.title,
    this.timeLimit = 300, // 5 minutes default
    required this.createdAt,
  });

  int get totalQuestions => questions.length;

  @override
  List<Object> get props => [
        id,
        chapterId,
        questions,
        title,
        timeLimit,
        createdAt,
      ];
}

class QuizQuestionEntity extends Equatable {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final int index;

  const QuizQuestionEntity({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.index,
  });

  bool isCorrectAnswer(String selectedAnswer) {
    return selectedAnswer == correctAnswer;
  }

  int get correctAnswerIndex {
    return options.indexOf(correctAnswer);
  }

  @override
  List<Object> get props => [question, options, correctAnswer, index];
}

class QuizAnswer extends Equatable {
  final int questionIndex;
  final String selectedAnswer;
  final bool isCorrect;

  const QuizAnswer({
    required this.questionIndex,
    required this.selectedAnswer,
    required this.isCorrect,
  });

  @override
  List<Object> get props => [questionIndex, selectedAnswer, isCorrect];
}

class QuizResult extends Equatable {
  final String quizId;
  final List<QuizAnswer> answers;
  final int score;
  final int totalQuestions;
  final int pointsEarned;
  final double percentage;
  final Duration timeTaken;

  const QuizResult({
    required this.quizId,
    required this.answers,
    required this.score,
    required this.totalQuestions,
    required this.pointsEarned,
    required this.percentage,
    required this.timeTaken,
  });

  @override
  List<Object> get props => [
        quizId,
        answers,
        score,
        totalQuestions,
        pointsEarned,
        percentage,
        timeTaken,
      ];
}
