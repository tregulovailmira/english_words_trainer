import 'dart:math';

import '../../features/vocabulary/domain/entities/question.dart';
import '../../features/vocabulary/domain/entities/word_entity.dart';

List<Question> generateQuestions(List<WordEntity> words) {
  if (words.length < 4) {
    return [];
  }
  final random = Random();
  final wordsListForOptions = words.map((word) => word.englishWord).toList();

  final wordsWithMeanings = words.where((word) => word.meanings.isNotEmpty);

  return wordsWithMeanings.map((word) {
    final meaningForQuestion = word.meanings.elementAt(
      random.nextInt(word.meanings.length),
    );

    final correctAnswer = word.englishWord;

    final wordsForIncorrectOprions =
        wordsListForOptions.where((word) => word != correctAnswer).toList();
    wordsForIncorrectOprions.shuffle();

    final incorrectAnswers = wordsForIncorrectOprions.getRange(0, 3).toList();

    final answers = [...incorrectAnswers, correctAnswer]..shuffle();

    final correctAnswerIndex = answers.indexOf(correctAnswer);

    return Question(
      question: meaningForQuestion,
      answers: answers,
      correctAnswerIndex: correctAnswerIndex,
    );
  }).toList();
}
