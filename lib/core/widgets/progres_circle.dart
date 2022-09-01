import 'package:flutter/material.dart';

class ProgressCircle extends StatelessWidget {
  final Color color;
  final double size;

  const ProgressCircle({this.color = Colors.white, this.size = 20, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color,
      ),
    );
  }
}
