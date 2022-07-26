import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage(this.message, {Key? key}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          message,
          style: const TextStyle(fontSize: 20, color: Colors.red),
          textAlign: TextAlign.center,
        ));
  }
}
