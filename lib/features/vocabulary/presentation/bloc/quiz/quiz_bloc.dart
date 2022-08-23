import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/question.dart';
import '../../../domain/entities/quiz_stats.dart';

part './quiz_event.dart';
part './quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc()
      : super(
          const QuizState(
            questions: [],
            stats: QuizStats(),
          ),
        ) {
    on<StartQuizEvent>((event, emit) {
      emit(
        QuizState(
          questions: event.questions,
          stats: const QuizStats(),
          isQuizPlaying: true,
        ),
      );
    });
    on<NextQuestionsEvent>((event, emit) {
      emit(
        QuizState(
          questions: state.questions,
          currentQuestionIndex: state.currentQuestionIndex + 1,
          stats: state.stats,
          isQuizPlaying: state.isQuizPlaying,
        ),
      );
    });
    on<ChooseAnswer>((event, emit) {
      final newStats = _updateStats(event.answerIndex);
      emit(
        QuizState(
          stats: newStats,
          questions: state.questions,
          currentQuestionIndex: state.currentQuestionIndex,
          isQuizPlaying: true,
        ),
      );
      _nextQuestion();
    });
    on<AddNotAnswered>((event, emit) {
      emit(
        QuizState(
          questions: state.questions,
          currentQuestionIndex: state.currentQuestionIndex,
          stats: QuizStats.addNoAnswer(
            state.questions[state.currentQuestionIndex],
            state.stats,
          ),
          isQuizPlaying: true,
        ),
      );
      _nextQuestion();
    });

    on<EndQuizEvent>((event, emit) {
      emit(
        QuizState(
          questions: const [],
          stats: state.stats,
          isQuizEnd: true,
          isQuizPlaying: false,
        ),
      );
    });
  }

  QuizStats _updateStats(int chosenAnswerIndex) {
    final foundQuestion = state.questions.elementAt(state.currentQuestionIndex);

    final questionForStats = Question(
      question: foundQuestion.question,
      answers: foundQuestion.answers,
      correctAnswerIndex: foundQuestion.correctAnswerIndex,
      chosenAnswerIndex: chosenAnswerIndex,
    );

    return questionForStats.isCorrect(chosenAnswerIndex)
        ? QuizStats.addCorrect(questionForStats, state.stats)
        : QuizStats.addWrong(questionForStats, state.stats);
  }

  void _nextQuestion() {
    if (state.currentQuestionIndex < state.questions.length - 1) {
      add(const NextQuestionsEvent());
    } else {
      add(const EndQuizEvent());
    }
  }
}
