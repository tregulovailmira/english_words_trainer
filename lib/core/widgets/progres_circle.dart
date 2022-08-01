import 'package:flutter/material.dart';

class ProgressCircle extends StatelessWidget {
  const ProgressCircle({Key? key, required this.color}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      strokeWidth: 2,
      color: color,
    ));
  }
}
