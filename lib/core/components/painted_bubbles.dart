import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../utils/double_values_generator.dart';

class PaintedBubbles extends CustomPainter {
  List<Bubble> bubbles;
  PaintedBubbles(this.bubbles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var bubble in bubbles) {
      canvas.drawCircle(
        bubble.position,
        bubble.radius,
        Paint()
          ..style = PaintingStyle.fill
          ..shader = ui.Gradient.radial(bubble.position, bubble.radius, [
            bubble.firstBubbleColor,
            bubble.secondBubbleColor,
          ]),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Bubble {
  Bubble({
    required double screenHeight,
    required double screenWidth,
    this.firstBubbleColor = Colors.white,
    this.secondBubbleColor = Colors.green,
    double minRadius = 15,
    double maxRadius = 50,
  }) {
    final initialPositionX = getRandom(0, screenWidth);
    final initialPositionY = getRandom(0, screenHeight);

    radius = getRandom(minRadius, maxRadius);
    position = Offset(initialPositionX, initialPositionY);
    dx = getRandom(-0.1, 0.1);
    dy = getRandom(-0.1, 0.1);
  }

  Color firstBubbleColor;
  Color secondBubbleColor;
  late double radius;
  late Offset position;
  late double dx;
  late double dy;
}
