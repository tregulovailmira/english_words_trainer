import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './stats_block_title.dart';
import './summary_question.dart';
import '../../bloc/quiz/quiz_bloc.dart';

class Stats extends StatelessWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizBloc, QuizState>(
      builder: (BuildContext context, state) {
        return ListView(
          children: [
            const StatsBlockTitle(title: 'Corrects:'),
            SummaryQuestions(
              questionsFromStats: state.stats.corrects,
            ),
            const SizedBox(
              height: 10,
            ),
            const StatsBlockTitle(title: 'Wrongs:'),
            SummaryQuestions(
              questionsFromStats: state.stats.wrongs,
            ),
            const SizedBox(
              height: 10,
            ),
            const StatsBlockTitle(title: 'Not Answered:'),
            SummaryQuestions(
              questionsFromStats: state.stats.noAnswered,
            ),
          ],
        );
      },
    );
  }
}
