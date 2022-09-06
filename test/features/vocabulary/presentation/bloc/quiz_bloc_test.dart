import 'dart:async';

import 'package:english_words_trainer/features/vocabulary/domain/entities/question.dart';
import 'package:english_words_trainer/features/vocabulary/domain/entities/quiz_stats.dart';
import 'package:english_words_trainer/features/vocabulary/presentation/bloc/quiz/quiz_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late QuizBloc quizBloc;
  const tQuestions = [
    Question(
      question: 'question',
      answers: ['word1', 'word2', 'word3', 'word4'],
      correctAnswerIndex: 1,
    ),
    Question(
      question: 'question1',
      answers: ['word1', 'word2', 'word3', 'word4'],
      correctAnswerIndex: 2,
    ),
    Question(
      question: 'question2',
      answers: ['word1', 'word2', 'word3', 'word4'],
      correctAnswerIndex: 0,
    )
  ];

  setUp(() {
    quizBloc = QuizBloc();
  });

  test('initial state should be empty', () {
    expect(
      quizBloc.state,
      equals(const QuizState(questions: [], stats: QuizStats())),
    );
  });

  test('should emit correct state on start quiz event', () {
    final tExpectedStates = [
      const QuizState(
        questions: tQuestions,
        stats: QuizStats(),
        isQuizPlaying: true,
      ),
    ];

    quizBloc.add(const StartQuizEvent(questions: tQuestions));
    expect(quizBloc.stream, emitsInOrder(tExpectedStates));
  });

  test('should emit correct state on next question event', () {
    final tExpectedStates = [
      const QuizState(
        questions: tQuestions,
        stats: QuizStats(),
        isQuizPlaying: true,
      ),
      const QuizState(
        questions: tQuestions,
        stats: QuizStats(),
        isQuizPlaying: true,
        currentQuestionIndex: 1,
      ),
    ];

    quizBloc.add(const StartQuizEvent(questions: tQuestions));
    quizBloc.add(NextQuestionsEvent());
    expect(quizBloc.stream, emitsInOrder(tExpectedStates));
  });

  test('should emit correct state on choose correct answer', () {
    const tChosenAnswerIndex = 1;
    final tCorrectAnswerStats = QuizStats.addCorrect(
      Question(
        question: tQuestions.first.question,
        answers: tQuestions.first.answers,
        correctAnswerIndex: tQuestions.first.correctAnswerIndex,
        chosenAnswerIndex: tChosenAnswerIndex,
      ),
      quizBloc.state.stats,
    );

    final tExpectedStates = [
      const QuizState(
        questions: tQuestions,
        stats: QuizStats(),
        isQuizPlaying: true,
      ),
      QuizState(
        stats: tCorrectAnswerStats,
        questions: tQuestions,
        isQuizPlaying: true,
      ),
      QuizState(
        stats: tCorrectAnswerStats,
        questions: tQuestions,
        currentQuestionIndex: 1,
        isQuizPlaying: true,
      ),
    ];

    quizBloc.add(const StartQuizEvent(questions: tQuestions));
    quizBloc.add(const ChooseAnswer(tChosenAnswerIndex));
    expect(quizBloc.stream, emitsInOrder(tExpectedStates));
  });

  test('should emit correct state on choose incorrect answer', () {
    const tChosenAnswerIndex = 2;
    final tWrongAnswerStats = QuizStats.addWrong(
      Question(
        question: tQuestions.first.question,
        answers: tQuestions.first.answers,
        correctAnswerIndex: tQuestions.first.correctAnswerIndex,
        chosenAnswerIndex: tChosenAnswerIndex,
      ),
      quizBloc.state.stats,
    );

    final tExpectedStates = [
      const QuizState(
        questions: tQuestions,
        stats: QuizStats(),
        isQuizPlaying: true,
      ),
      QuizState(
        stats: tWrongAnswerStats,
        questions: tQuestions,
        isQuizPlaying: true,
      ),
      QuizState(
        stats: tWrongAnswerStats,
        questions: tQuestions,
        currentQuestionIndex: 1,
        isQuizPlaying: true,
      ),
    ];

    quizBloc.add(const StartQuizEvent(questions: tQuestions));
    quizBloc.add(const ChooseAnswer(tChosenAnswerIndex));
    expect(quizBloc.stream, emitsInOrder(tExpectedStates));
  });

  test('should emit correct state answer wasn\'t chosen', () {
    final tNoAnswerStats = QuizStats.addNoAnswer(
      Question(
        question: tQuestions.first.question,
        answers: tQuestions.first.answers,
        correctAnswerIndex: tQuestions.first.correctAnswerIndex,
      ),
      quizBloc.state.stats,
    );

    final tExpectedStates = [
      const QuizState(
        questions: tQuestions,
        stats: QuizStats(),
        isQuizPlaying: true,
      ),
      QuizState(
        stats: tNoAnswerStats,
        questions: tQuestions,
        isQuizPlaying: true,
      ),
      QuizState(
        stats: tNoAnswerStats,
        questions: tQuestions,
        currentQuestionIndex: 1,
        isQuizPlaying: true,
      ),
    ];

    quizBloc.add(const StartQuizEvent(questions: tQuestions));
    quizBloc.add(AddNotAnswered());
    expect(quizBloc.stream, emitsInOrder(tExpectedStates));
  });

  test('should emit correct state on quiz end', () {
    const tQuestionsList = [
      Question(
        question: 'question',
        answers: ['word1', 'word2', 'word3', 'word4'],
        correctAnswerIndex: 1,
      ),
      Question(
        question: 'question1',
        answers: ['word1', 'word2', 'word3', 'word4'],
        correctAnswerIndex: 2,
      ),
    ];

    final tFirstAnswerStats = QuizStats.addNoAnswer(
      Question(
        question: tQuestionsList.first.question,
        answers: tQuestionsList.first.answers,
        correctAnswerIndex: tQuestionsList.first.correctAnswerIndex,
      ),
      quizBloc.state.stats,
    );
    final tSecondAnswerStats = QuizStats.addNoAnswer(
      Question(
        question: tQuestionsList[1].question,
        answers: tQuestionsList[1].answers,
        correctAnswerIndex: tQuestionsList[1].correctAnswerIndex,
      ),
      tFirstAnswerStats,
    );

    final tExpectedStates = [
      const QuizState(
        questions: tQuestionsList,
        stats: QuizStats(),
        isQuizPlaying: true,
      ),
      QuizState(
        stats: tFirstAnswerStats,
        questions: tQuestionsList,
        isQuizPlaying: true,
      ),
      QuizState(
        stats: tFirstAnswerStats,
        questions: tQuestionsList,
        currentQuestionIndex: 1,
        isQuizPlaying: true,
      ),
      QuizState(
        stats: tSecondAnswerStats,
        questions: tQuestionsList,
        currentQuestionIndex: 1,
        isQuizPlaying: true,
      ),
      QuizState(
        stats: tSecondAnswerStats,
        questions: const [],
        isQuizPlaying: false,
        isQuizEnd: true,
      ),
    ];

    quizBloc.add(const StartQuizEvent(questions: tQuestionsList));
    Timer(const Duration(microseconds: 500), () {
      quizBloc.add(AddNotAnswered());
    });
    Timer(const Duration(seconds: 1), () {
      quizBloc.add(AddNotAnswered());
    });
    expect(quizBloc.stream, emitsInOrder(tExpectedStates));
  });
}
