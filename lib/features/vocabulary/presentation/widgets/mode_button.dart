import 'package:flutter/material.dart';

class NavigateModeButton extends StatelessWidget {
  final String route;
  final String buttonText;
  const NavigateModeButton({
    required this.buttonText,
    required this.route,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        ),
      ),
      onPressed: () => Navigator.of(context).pushNamed(route),
      child: Text(buttonText, style: const TextStyle(fontSize: 17)),
    );
  }
}
