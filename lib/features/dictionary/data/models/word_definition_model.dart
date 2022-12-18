import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/word_definition.dart';

part 'word_definition_model.freezed.dart';
part 'word_definition_model.g.dart';

@freezed
abstract class WordDefinitionModel implements _$WordDefinitionModel {
  const WordDefinitionModel._();

  factory WordDefinitionModel({
    String? type,
    String? definition,
    String? example,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'image_url') String? imageUrl,
    String? emoji,
  }) = _WordDefinitionModel;

  factory WordDefinitionModel.fromJson(Map<String, dynamic> json) =>
      _$WordDefinitionModelFromJson(json);

  factory WordDefinitionModel.fromDomain(WordDefinition definition) {
    return WordDefinitionModel(
      type: definition.type,
      definition: definition.definition,
      example: definition.example,
      imageUrl: definition.imageUrl,
      emoji: definition.emoji,
    );
  }

  WordDefinition toDomain() {
    return WordDefinition(
      type: type,
      definition: definition,
      example: example,
      imageUrl: imageUrl,
      emoji: emoji,
    );
  }
}
