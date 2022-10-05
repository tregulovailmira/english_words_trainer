import 'package:flutter/material.dart';

class SourceSelectionOption extends StatelessWidget {
  const SourceSelectionOption({
    required this.onTap,
    required this.text,
    Key? key,
  }) : super(key: key);

  final Function() onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black54,
        ),
      ),
    );
  }
}
