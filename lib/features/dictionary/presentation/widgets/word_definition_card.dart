import 'package:flutter/material.dart';

import '../../domain/entities/word_definition.dart';
import 'cards_text.dart';

class WordDefinitionCard extends StatelessWidget {
  const WordDefinitionCard({required this.definition, Key? key})
      : super(key: key);

  final WordDefinition definition;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (definition.type != null)
          CardsText(
            text: definition.type!,
          ),
        const SizedBox(
          height: 5,
        ),
        if (definition.definition != null)
          CardsText(
            text: definition.definition!,
            fontWeight: FontWeight.normal,
          ),
        const SizedBox(
          height: 5,
        ),
        if (definition.example != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CardsText(text: 'Example:'),
              CardsText(
                text: definition.example!,
                fontWeight: FontWeight.normal,
              ),
            ],
          ),
        const SizedBox(
          height: 5,
        ),
        if (definition.imageUrl != null)
          Image.network(
            definition.imageUrl!,
            scale: 2,
          ),
      ],
    );
  }
}
