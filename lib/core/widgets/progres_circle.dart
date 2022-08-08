import 'package:flutter/material.dart';

class ProgressCircle extends StatelessWidget {
  final Color color;

  const ProgressCircle({required this.color, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: color,
      ),
    );
  }
}
