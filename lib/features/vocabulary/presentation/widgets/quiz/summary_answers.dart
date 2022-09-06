import 'package:flutter/material.dart';
import '../../../domain/entities/question.dart';

class SummaryAnswers extends StatelessWidget {
  const SummaryAnswers({required this.question, Key? key}) : super(key: key);

  final Question question;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      key: UniqueKey(),
      itemCount: question.answers.length,
      itemBuilder: (BuildContext context, int index) {
        return Text(
          question.answers.elementAt(index),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: question.isCorrect(index)
                ? Colors.green
                : question.isChosen(index)
                    ? Colors.red
                    : Colors.grey,
          ),
        );
      },
    );
  }
}
