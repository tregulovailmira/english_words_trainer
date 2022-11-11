import 'package:flutter/material.dart';

class CardsText extends StatelessWidget {
  const CardsText({
    required this.text,
    this.color,
    this.fontWeight = FontWeight.bold,
    this.fontSize = 15.0,
    Key? key,
  }) : super(key: key);

  final String text;
  final Color? color;
  final FontWeight fontWeight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? Theme.of(context).colorScheme.primary,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }
}
