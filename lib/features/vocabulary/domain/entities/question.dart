import 'package:equatable/equatable.dart';

class Question extends Equatable {
  const Question({
    required this.question,
    required this.answers,
    required this.correctAnswerIndex,
    this.chosenAnswerIndex,
  });

  final String question;
  final List<String> answers;
  final int correctAnswerIndex;
  final int? chosenAnswerIndex;

  bool isCorrect(int answerIndex) {
    return answerIndex == correctAnswerIndex;
  }

  bool isChosen(int answerIndex) {
    return chosenAnswerIndex != null ? answerIndex == chosenAnswerIndex : false;
  }

  @override
  List<Object?> get props => [
        question,
        answers,
        correctAnswerIndex,
        chosenAnswerIndex,
      ];
}
