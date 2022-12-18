import 'package:equatable/equatable.dart';

import 'word_definition.dart';

class WordDescription extends Equatable {
  const WordDescription({
    required this.definitions,
    required this.word,
    required this.pronunciation,
  });

  final List<WordDefinition> definitions;
  final String word;
  final String? pronunciation;

  @override
  List<Object?> get props => [
        definitions,
        word,
        pronunciation,
      ];
}
