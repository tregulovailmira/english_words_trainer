import 'package:flutter/material.dart';

import '../../domain/entities/word_entity.dart';

class AddOrEditWordForm extends StatelessWidget {
  final BuildContext blocContext;
  final TextEditingController englishWordController;
  final TextEditingController translationController;
  final Function onSubmit;
  final String title;
  final WordEntity? word;

  const AddOrEditWordForm({
    required this.blocContext,
    required this.englishWordController,
    required this.translationController,
    required this.onSubmit,
    required this.title,
    this.word,
    Key? key,
  }) : super(key: key);

  void onPressedHandler() {
    onSubmit();
    englishWordController.clear();
    translationController.clear();
    Navigator.of(blocContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(15),
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Word in english',
            border: OutlineInputBorder(),
          ),
          controller: englishWordController,
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Translation',
            border: OutlineInputBorder(),
          ),
          controller: translationController,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onPressedHandler,
                child: const Text('OK'),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade600),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  englishWordController.clear();
                  translationController.clear();
                },
                child: const Text('Cancel'),
              ),
            ),
          ],
        )
      ],
    );
  }
}
