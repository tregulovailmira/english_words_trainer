part of 'quiz_bloc.dart';

class QuizState extends Equatable {
  final List<Question> questions;
  final int currentQuestionIndex;
  final bool isQuizEnd;
  final QuizStats stats;
  final bool isQuizPlaying;

  const QuizState({
    required this.questions,
    required this.stats,
    this.currentQuestionIndex = 0,
    this.isQuizEnd = false,
    this.isQuizPlaying = false,
  });

  @override
  List<Object> get props => [
        questions,
        currentQuestionIndex,
        isQuizEnd,
        stats,
        isQuizPlaying,
      ];
}
