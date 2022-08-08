import 'package:flutter/material.dart';

import '../../../../core/utils/validatior.dart';

class GuessWordForm extends StatefulWidget {
  final String guessWordOrPhrase;
  final Function onSubmit;

  const GuessWordForm(
      {required this.guessWordOrPhrase, required this.onSubmit, Key? key})
      : super(key: key);

  @override
  GuessWordFormState createState() => GuessWordFormState();
}

class GuessWordFormState extends State<GuessWordForm> {
  static const emptyChar = '\u200b';
  final _formKey = GlobalKey<FormState>();
  List<Widget> charInputsList = [];
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    _setInputsState();
  }

  @override
  void didUpdateWidget(covariant GuessWordForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    FocusScope.of(context).unfocus();
    _formKey.currentState!.reset();
    _setInputsState();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _setInputsState() {
    final newControllers = List.generate(
      widget.guessWordOrPhrase.length,
      (index) => TextEditingController(text: emptyChar),
    );
    setState(() {
      controllers = newControllers;
      charInputsList = _generateInputsList(newControllers);
    });
  }

  void _onSubmitHandler() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit();
    }
  }

  void _onCancelHandler() {
    for (var controller in controllers) {
      controller.text = emptyChar;
    }
    _formKey.currentState!.reset();
  }

  _generateInputsList(controllersList) {
    final List<Widget> widgetsList = [];
    final charsArray = widget.guessWordOrPhrase.split('');
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
                controller: controllersList[i],
                validator: (value) => CharValidator()
                    .validate(value!, widget.guessWordOrPhrase[i]),
                onChanged: (value) {
                  if (value.isEmpty) {
                    controllersList[i].text = emptyChar;
                    FocusScope.of(context).previousFocus();
                    return;
                  } else if (value.length == 2) {
                    controllersList[i].text = controllersList[i].text[1];
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
    return widgetsList;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Wrap(
            runSpacing: 15,
            alignment: WrapAlignment.center,
            children: charInputsList,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _onSubmitHandler,
                child: const Icon(
                  Icons.check,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: _onCancelHandler,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey),
                ),
                child: const Icon(
                  Icons.cancel_outlined,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
