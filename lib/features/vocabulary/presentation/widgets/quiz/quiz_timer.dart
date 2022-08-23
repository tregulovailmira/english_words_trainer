import 'dart:async';

import 'package:flutter/material.dart';

class QuizTimer extends StatefulWidget {
  const QuizTimer({
    required this.tick,
    required this.onTimeEnd,
    this.countdown = 10,
    Key? key,
  })  : assert(countdown > 1),
        super(key: key);

  final int tick;
  final Function onTimeEnd;
  final int countdown;

  @override
  State<QuizTimer> createState() => _QuizTimerState();
}

class _QuizTimerState extends State<QuizTimer> {
  static const refreshTime = 1;
  late int currentTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    currentTime = widget.countdown;
    _playTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(QuizTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    timer.cancel();
    if (widget.tick != oldWidget.tick) {
      _refreshTimer();
    }
  }

  _playTimer() {
    timer = Timer.periodic(
      const Duration(seconds: refreshTime),
      (Timer t) {
        setState(() {
          currentTime = widget.countdown - refreshTime * t.tick;
        });

        if (currentTime == 0) {
          timer.cancel();
          widget.onTimeEnd();
        }
      },
    );
  }

  void _refreshTimer() {
    setState(() {
      currentTime = widget.countdown;
    });
    _playTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: currentTime / widget.countdown,
            valueColor:
                AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
            backgroundColor: Colors.red,
          ),
          Center(
            child: Text(
              currentTime.toString(),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
