import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}

extension DateFormatter on DateTime {
  String formatDate({
    String format = 'yyyy/MM/dd HH:mm:ss',
  }) {
    return DateFormat(format).format(this);
  }
}
