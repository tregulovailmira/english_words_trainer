import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/quiz/quiz_bloc.dart';

class QuizOptionsButtons extends StatefulWidget {
  const QuizOptionsButtons({
    required this.answers,
    required this.correctAnswerIndex,
    required this.onTapHandler,
    Key? key,
  }) : super(key: key);

  final List<String> answers;
  final int correctAnswerIndex;
  final Function onTapHandler;

  @override
  State<QuizOptionsButtons> createState() => _QuizOptionsButtonsState();
}

class _QuizOptionsButtonsState extends State<QuizOptionsButtons> {
  static const optionsLetters = ['A', 'B', 'C', 'D'];
  final GlobalKey<AnimatedListState> _key = GlobalKey<AnimatedListState>();
  final List<String> _listItems = [];
  List<Color> optionColors = List.generate(
    optionsLetters.length,
    (index) => Colors.white,
  );

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void didUpdateWidget(covariant QuizOptionsButtons oldWidget) {
    if (oldWidget.answers != widget.answers) {
      super.didUpdateWidget(oldWidget);
      _unloadItems();
      _loadItems();
    }
  }

  void _loadItems() {
    // imitation of data fetching for animation the list

    for (var i = 0; i < widget.answers.length; i++) {
      Future.delayed(const Duration(milliseconds: 0), () {
        _listItems.add(widget.answers[i]);
        _key.currentState
            ?.insertItem(i, duration: const Duration(milliseconds: 500));
      });
    }
  }

  void _unloadItems() {
    for (var i = _listItems.length - 1; i >= 0; i--) {
      _listItems.removeAt(i);
      _key.currentState?.removeItem(
        i,
        (context, animation) => const SizedBox(),
      );
    }
  }

  void Function() onTapHandler(answerIndex) => () {
        optionColors[answerIndex] = answerIndex == widget.correctAnswerIndex
            ? Colors.green.shade300
            : Colors.red.shade300;

        widget.onTapHandler();
        Timer(const Duration(seconds: 1), () {
          context.read<QuizBloc>().add(ChooseAnswer(answerIndex));
          optionColors[answerIndex] = Colors.white;
        });
      };

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedList(
        key: _key,
        itemBuilder: (
          BuildContext context,
          int index,
          Animation<double> animation,
        ) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.5,
                end: 1,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeIn,
                ),
              ),
              child: ListTile(
                dense: true,
                onTap: onTapHandler(index),
                tileColor: optionColors[index],
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    optionsLetters[index],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                title: Text(
                  _listItems.elementAt(index),
                  style: const TextStyle(fontSize: 15),
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 2,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          );
        },
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
      ),
    );
  }
}
