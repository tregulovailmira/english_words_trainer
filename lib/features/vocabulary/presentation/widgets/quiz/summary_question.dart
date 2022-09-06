import 'package:flutter/material.dart';

import './summary_answers.dart';
import '../../../domain/entities/question.dart';

class SummaryQuestions extends StatelessWidget {
  const SummaryQuestions({
    required this.questionsFromStats,
    Key? key,
  }) : super(key: key);

  final List<Question> questionsFromStats;

  @override
  Widget build(BuildContext context) {
    if (questionsFromStats.isEmpty) {
      return const Text(
        '-',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
          color: Colors.black,
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: questionsFromStats.length,
      key: UniqueKey(),
      separatorBuilder: (context, index) => const Divider(
        thickness: 2,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Text(
              questionsFromStats[index].question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            SummaryAnswers(
              question: questionsFromStats[index],
            ),
          ],
        );
      },
    );
  }
}
