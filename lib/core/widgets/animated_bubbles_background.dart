import 'dart:async';

import 'package:flutter/material.dart';

import '../components/painted_bubbles.dart';

class AnimatedBubblesBackground extends StatefulWidget {
  const AnimatedBubblesBackground({
    required this.pageHeight,
    required this.pageWidth,
    this.firstBubbleColor,
    this.secondBubbleColor,
    this.minRadius,
    this.maxRadius,
    this.bubblesAmount = 20,
    this.duration = 15,
    Key? key,
  }) : super(key: key);

  final double pageHeight;
  final double pageWidth;
  final int bubblesAmount;
  final int duration;
  final Color? firstBubbleColor;
  final Color? secondBubbleColor;
  final int? minRadius;
  final int? maxRadius;

  @override
  State<AnimatedBubblesBackground> createState() =>
      _AnimatedBubblesBackgroundState();
}

class _AnimatedBubblesBackgroundState extends State<AnimatedBubblesBackground> {
  late List<Bubble> bubbles;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    generateBubblesList();
    initBubblesAnimation();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PaintedBubbles(bubbles),
    );
  }

  void generateBubblesList() {
    bubbles = List<Bubble>.generate(
      widget.bubblesAmount,
      (index) => Bubble(
        screenHeight: widget.pageHeight,
        screenWidth: widget.pageWidth,
      ),
    );
  }

  void initBubblesAnimation() {
    final duration = Duration(milliseconds: widget.duration);
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        for (var bubble in bubbles) {
          if (isScreenBoundary(bubble)) {
            bubble.dx = -bubble.dx;
            bubble.dy = -bubble.dy;
          }
          bubble.position += Offset(bubble.dx, bubble.dy);
        }
      });
    });
  }

  bool isScreenBoundary(Bubble bubble) =>
      bubble.position.dy >= widget.pageHeight ||
      bubble.position.dy <= 0 ||
      bubble.position.dx >= widget.pageWidth ||
      bubble.position.dx <= 0;
}
