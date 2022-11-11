import 'package:flutter/material.dart';

import './cards_text.dart';
import './definitions_list.dart';
import '../../domain/entities/word_description.dart';

class WordCard extends StatelessWidget {
  const WordCard({required this.word, Key? key}) : super(key: key);

  final WordDescription word;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: const EdgeInsets.fromLTRB(5, 0, 5, 50),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardsText(
            text: word.word,
            fontSize: 20,
          ),
          if (word.pronunciation != null)
            CardsText(
              text: word.pronunciation!,
              fontSize: 13,
            ),
          Divider(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          DefinitionsList(
            definitions: word.definitions,
          ),
        ],
      ),
    );
  }
}
