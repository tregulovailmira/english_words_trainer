import 'package:equatable/equatable.dart';

import '../../domain/entities/word_api_description_entity.dart';

class WordDescriptionModel extends Equatable {
  final String word;
  final List<String> meanings;
  final String? listeningUrl;

  const WordDescriptionModel({
    required this.word,
    required this.meanings,
    this.listeningUrl,
  });

  factory WordDescriptionModel.fromJson(Map<String, dynamic> json) {
    final gottenWord = json['word'];

    final List<String> gottenMeanings = [];
    for (var meaning in (json['meanings'] as List)) {
      for (var def in (meaning['definitions'] as List)) {
        gottenMeanings.add(def['definition']);
      }
    }

    final String gottenUrl = json['phonetics'][0]['audio'];

    return WordDescriptionModel(
      word: gottenWord,
      meanings: gottenMeanings,
      listeningUrl: gottenUrl.isEmpty ? null : gottenUrl,
    );
  }

  WordApiDescriptionEntity toDomain() {
    return WordApiDescriptionEntity(
      word: word,
      meanings: meanings,
      listeningUrl: listeningUrl,
    );
  }

  @override
  List<Object?> get props => [word, meanings, listeningUrl];
}
