part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class StartQuizEvent extends QuizEvent {
  final List<Question> questions;

  const StartQuizEvent({required this.questions});

  @override
  List<Object> get props => [questions];
}

class NextQuestionsEvent extends QuizEvent {}

class ChooseAnswer extends QuizEvent {
  final int answerIndex;

  const ChooseAnswer(this.answerIndex);

  @override
  List<Object> get props => [answerIndex];
}

class AddNotAnswered extends QuizEvent {}

class EndQuizEvent extends QuizEvent {}
