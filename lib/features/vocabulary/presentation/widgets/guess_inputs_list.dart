import 'package:flutter/material.dart';

import '../../../../core/utils/validatior.dart';

class GuessInputsList extends StatelessWidget {
  static const emptyChar = '\u200b';
  final String guessWordOrPhrase;
  final List<TextEditingController> controllers;

  const GuessInputsList({
    required this.guessWordOrPhrase,
    required this.controllers,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetsList = [];

    final charsArray = guessWordOrPhrase.split('');
    for (var i = 0; i < charsArray.length; i++) {
      if (charsArray[i] == '-') {
        widgetsList.add(
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              '-',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        );
      } else if (charsArray[i] == ' ') {
        widgetsList.add(
          SizedBox(
            width: MediaQuery.of(context).size.width,
          ),
        );
      } else {
        widgetsList.add(
          SizedBox(
            width: 30,
            height: 30,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: TextFormField(
                controller: controllers[i],
                validator: (value) =>
                    CharValidator().validate(value!, guessWordOrPhrase[i]),
                onChanged: (value) {
                  if (value.isEmpty) {
                    controllers[i].text = emptyChar;
                    FocusScope.of(context).previousFocus();
                    return;
                  } else if (value.length == 2) {
                    controllers[i].text = controllers[i].text[1];
                    FocusScope.of(context).nextFocus();
                  }
                },
                textAlign: TextAlign.center,
                maxLength: 2,
                decoration: const InputDecoration(
                  errorStyle: TextStyle(height: 0),
                  counterText: '',
                ),
              ),
            ),
          ),
        );
      }
    }
    return Wrap(
      runSpacing: 15,
      alignment: WrapAlignment.center,
      children: widgetsList,
    );
  }
}
