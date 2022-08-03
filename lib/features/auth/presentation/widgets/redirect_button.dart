import 'package:flutter/material.dart';

class RedirectButton extends StatelessWidget {
  final String route;
  final String buttonText;

  const RedirectButton(this.route, this.buttonText, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(route, (route) => false);
        },
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          foregroundColor:
              MaterialStateProperty.all(Theme.of(context).colorScheme.primary),
          backgroundColor:
              MaterialStateProperty.all(Colors.white.withOpacity(0)),
          textStyle: MaterialStateProperty.all(const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            decoration: TextDecoration.underline,
          )),
        ),
        child: Text(buttonText));
  }
}
