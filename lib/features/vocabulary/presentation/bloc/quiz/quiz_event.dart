part of 'quiz_bloc.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

class StartQuizEvent extends QuizEvent {
  final List<Question> questions;

  const StartQuizEvent({required this.questions});
}

class NextQuestionsEvent extends QuizEvent {
  const NextQuestionsEvent();
}

class ChooseAnswer extends QuizEvent {
  final int answerIndex;

  const ChooseAnswer(this.answerIndex);
}

class AddNotAnswered extends QuizEvent {}

class EndQuizEvent extends QuizEvent {
  const EndQuizEvent();
}
