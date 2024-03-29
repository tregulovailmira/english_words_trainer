import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/word_entity.dart';

part 'word_model.freezed.dart';
part 'word_model.g.dart';

@freezed
abstract class WordModel implements _$WordModel {
  const WordModel._();

  const factory WordModel({
    required int id,
    required String userId,
    required String englishWord,
    required String translation,
    required List<String> meanings,
    required DateTime createdAt,
    String? listeningUrl,
  }) = _WordModel;

  factory WordModel.fromJson(Map<String, dynamic> json) =>
      _$WordModelFromJson(json);

  factory WordModel.fromDomain(WordEntity word) {
    return WordModel(
      id: word.id,
      userId: word.userId,
      englishWord: word.englishWord,
      translation: word.translation,
      listeningUrl: word.listeningUrl,
      meanings: word.meanings,
      createdAt: word.createdAt,
    );
  }

  WordEntity toDomain() {
    return WordEntity(
      id: id,
      userId: userId,
      englishWord: englishWord,
      translation: translation,
      listeningUrl: listeningUrl,
      meanings: meanings,
      createdAt: createdAt,
    );
  }
}
