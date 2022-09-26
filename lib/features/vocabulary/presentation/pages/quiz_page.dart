import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/auth_required_state.dart';
import '../../../../core/utils/questions_generator.dart';
import '../../../../routes.dart';
import '../../domain/entities/question.dart';
import '../bloc/quiz/quiz_bloc.dart';
import '../bloc/words_list_bloc.dart';
import '../widgets/quiz/quiz_widget.dart';
import '../widgets/quiz/stats.dart';
import '../widgets/quiz/stats_bar.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends AuthRequiredState<QuizPage> {
  List<Question> questions = [];

  @override
  void initState() {
    super.initState();
    _setQuestions();
  }

  void _setQuestions() {
    final wordsList = context.read<WordsListBloc>().state.words;
    setState(() {
      questions = generateQuestions(wordsList);
    });
    if (questions.isNotEmpty) {
      context.read<QuizBloc>().add(StartQuizEvent(questions: questions));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizBloc, QuizState>(
      builder: (BuildContext context, state) {
        if (state.isQuizEnd) {
          return const Scaffold(
            appBar: StatsBar(),
            body: Stats(),
          );
        }
        if (state.isQuizPlaying) {
          return const Scaffold(
            appBar: StatsBar(),
            body: QuizWidget(),
          );
        }
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Add at least 4 words with descriptions',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.myVocabulary,
                    (route) => false,
                  );
                },
                child: const Text('Back To Vocabulary'),
              )
            ],
          ),
        );
      },
    );
  }
}
