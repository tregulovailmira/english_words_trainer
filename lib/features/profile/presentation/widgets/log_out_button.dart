import 'package:flutter/material.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({required this.onPressed, Key? key}) : super(key: key);

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
        elevation: MaterialStateProperty.all(0),
        foregroundColor: MaterialStateProperty.all(
          Theme.of(context).colorScheme.primary,
        ),
        backgroundColor: MaterialStateProperty.all(
          Colors.white.withOpacity(0),
        ),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      child: Text(
        'Log out',
        style: TextStyle(
          fontSize: 15,
          color: Colors.red.shade300,
        ),
      ),
    );
  }
}
