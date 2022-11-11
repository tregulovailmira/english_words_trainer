import 'package:flutter/material.dart';

import './word_definition_card.dart';
import '../../domain/entities/word_definition.dart';

class DefinitionsList extends StatelessWidget {
  const DefinitionsList({
    required this.definitions,
    Key? key,
  }) : super(key: key);

  final List<WordDefinition> definitions;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(
        height: 25,
      ),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: definitions.length,
      itemBuilder: (BuildContext context, int index) {
        return WordDefinitionCard(
          definition: definitions[index],
        );
      },
    );
  }
}
