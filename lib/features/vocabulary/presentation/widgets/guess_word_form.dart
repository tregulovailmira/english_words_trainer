import 'package:flutter/material.dart';

import './guess_inputs_list.dart';

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
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();
    _setControllers();
  }

  @override
  void didUpdateWidget(covariant GuessWordForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    FocusScope.of(context).unfocus();
    _formKey.currentState!.reset();
    _setControllers();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _setControllers() {
    setState(() {
      controllers = List.generate(
        widget.guessWordOrPhrase.length,
        (index) => TextEditingController(text: emptyChar),
      );
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          GuessInputsList(
            controllers: controllers,
            guessWordOrPhrase: widget.guessWordOrPhrase,
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
