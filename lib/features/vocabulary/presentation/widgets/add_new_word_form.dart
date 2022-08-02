import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/progres_circle.dart';
import '../bloc/words_list_bloc.dart';

class AddNewWordForm extends StatelessWidget {
  AddNewWordForm(
      {required this.userId,
      required this.blocContext,
      required this.isLoading,
      Key? key})
      : super(key: key);

  final String userId;
  final BuildContext blocContext;
  final bool isLoading;
  final englishWordController = TextEditingController();
  final translationController = TextEditingController();

  void onPressedHandler() {
    final word = {
      'englishWord': englishWordController.text,
      'translation': translationController.text,
      'userId': userId,
    };
    BlocProvider.of<WordsListBloc>(blocContext).add(AddWordEvent(word));
    Navigator.of(blocContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(15),
      title: const Text(
        'Add new word',
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
                child: isLoading
                    ? const ProgressCircle(color: Colors.white)
                    : const Text('Add'),
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
              },
              child: const Text('Cancel'),
            )),
          ],
        )
      ],
    );
  }
}
