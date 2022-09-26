import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({required this.question, Key? key}) : super(key: key);
  final String question;

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void didUpdateWidget(covariant QuestionWidget oldWidget) {
    if (oldWidget.question != widget.question) {
      super.didUpdateWidget(oldWidget);
      animController.reset();
      animController.forward();
    }
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  void _initAnimation() {
    animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.easeIn,
    );

    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      });

    animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Transform.scale(
        scale: animation.value,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(30),
          child: Text(
            widget.question,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
