import 'package:flutter/material.dart';

import '../../domain/entities/word_entity.dart';

class WordsListView extends StatelessWidget {
  const WordsListView({required this.wordsList, Key? key}) : super(key: key);

  final List<WordEntity> wordsList;

  static const englishTextStyle = TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const translationTextStyle = TextStyle(
    fontSize: 15,
    color: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    if (wordsList.isNotEmpty) {
      return ListView.separated(
        itemCount: wordsList.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: <Widget>[
              const Icon(Icons.volume_up_sharp),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wordsList[index].englishWord,
                    style: englishTextStyle,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    wordsList[index].translation,
                    style: translationTextStyle,
                    overflow: TextOverflow.clip,
                  )
                ],
              )
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      );
    } else {
      return Center(
          child: Text(
        'No words added yet :(',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ));
    }
  }
}
