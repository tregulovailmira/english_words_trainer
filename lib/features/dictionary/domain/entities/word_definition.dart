import 'package:equatable/equatable.dart';

class WordDefinition extends Equatable {
  const WordDefinition({
    this.type,
    this.definition,
    this.example,
    this.imageUrl,
    this.emoji,
  });

  final String? type;
  final String? definition;
  final String? example;
  final String? imageUrl;
  final String? emoji;

  @override
  List<Object?> get props => [
        type,
        definition,
        example,
        imageUrl,
        emoji,
      ];
}
