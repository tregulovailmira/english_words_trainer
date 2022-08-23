import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/quiz/quiz_bloc.dart';

class StatsBar extends StatelessWidget implements PreferredSizeWidget {
  const StatsBar({Key? key}) : super(key: key);

  static const _height = 55.0;

  static const _numberAnswersStyle = TextStyle(
    fontSize: 15,
    fontStyle: FontStyle.italic,
  );

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override 
  Widget build(BuildContext context) {
    return BlocBuilder<QuizBloc, QuizState>(
      builder: (BuildContext context, state) {
        return AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              Text(
                'SCORE: ${state.stats.score.toString()}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Correct: ${state.stats.corrects.length.toString()}',
                    style: _numberAnswersStyle,
                  ),
                  Text(
                    'Wrongs: ${state.stats.wrongs.length.toString()}',
                    style: _numberAnswersStyle,
                  ),
                  Text(
                    'Not Answered: ${state.stats.noAnswered.length.toString()}',
                    style: _numberAnswersStyle,
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
