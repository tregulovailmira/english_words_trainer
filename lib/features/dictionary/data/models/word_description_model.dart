import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/word_description.dart';
import 'word_definition_model.dart';

part 'word_description_model.freezed.dart';
part 'word_description_model.g.dart';

@freezed
abstract class WordDescriptionModel implements _$WordDescriptionModel {
  const WordDescriptionModel._();

  const factory WordDescriptionModel({
    required List<WordDefinitionModel> definitions,
    required String word,
    required String? pronunciation,
  }) = _WordDescriptionModel;

  factory WordDescriptionModel.fromJson(Map<String, dynamic> json) =>
      _$WordDescriptionModelFromJson(json);

  factory WordDescriptionModel.fromDomain(WordDescription description) {
    final definitions = description.definitions
        .map((definition) => WordDefinitionModel.fromDomain(definition))
        .toList();
    return WordDescriptionModel(
      definitions: definitions,
      word: description.word,
      pronunciation: description.pronunciation,
    );
  }

  WordDescription toDomain() {
    final domainDefinitions =
        definitions.map((definition) => definition.toDomain()).toList();

    return WordDescription(
      definitions: domainDefinitions,
      word: word,
      pronunciation: pronunciation,
    );
  }
}
