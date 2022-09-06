import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './quiz_options_buttons.dart';
import './quiz_timer.dart';
import '../../bloc/quiz/quiz_bloc.dart';
import 'question_widget.dart';

class QuizWidget extends StatefulWidget {
  const QuizWidget({Key? key}) : super(key: key);

  @override
  QuizWidgetState createState() => QuizWidgetState();
}

class QuizWidgetState extends State<QuizWidget> {
  void onTimeEnd() {
    context.read<QuizBloc>().add(AddNotAnswered());
  }

  void onTimerStop() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizBloc, QuizState>(
      builder: (blocContext, state) {
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    QuizTimer(
                      tick: state.currentQuestionIndex,
                      onTimeEnd: onTimeEnd,
                    ),
                  ],
                ),
              ),
              QuestionWidget(
                question: state.questions
                    .elementAt(state.currentQuestionIndex)
                    .question,
              ),
              QuizOptionsButtons(
                onTapHandler: onTimerStop,
                answers: state.questions
                    .elementAt(state.currentQuestionIndex)
                    .answers,
                correctAnswerIndex: state.questions
                    .elementAt(state.currentQuestionIndex)
                    .correctAnswerIndex,
              ),
            ],
          ),
        );
      },
    );
  }
}
