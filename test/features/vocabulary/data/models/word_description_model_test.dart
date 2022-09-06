import 'dart:convert';

import 'package:english_words_trainer/features/vocabulary/data/models/word_description_model.dart';
import 'package:english_words_trainer/features/vocabulary/domain/entities/word_api_description_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tWordDescriptionModel = WordDescriptionModel(
    word: 'attract',
    meanings: [
      'To pull toward without touching.',
      'To arouse interest.',
      'To draw by moral, emotional or sexual influence; to engage or fix, as the mind, attention, etc.; to invite or allure.'
    ],
    listeningUrl:
        'https://api.dictionaryapi.dev/media/pronunciations/en/attract-uk.mp3',
  );

  const tWordDescriptionEntity = WordApiDescriptionEntity(
    word: 'attract',
    meanings: [
      'To pull toward without touching.',
      'To arouse interest.',
      'To draw by moral, emotional or sexual influence; to engage or fix, as the mind, attention, etc.; to invite or allure.'
    ],
    listeningUrl:
        'https://api.dictionaryapi.dev/media/pronunciations/en/attract-uk.mp3',
  );

  test('should return correct model from json', () {
    final result = WordDescriptionModel.fromJson(
      json.decode(fixture('api_success_response.json'))[0],
    );

    expect(result, equals(tWordDescriptionModel));
  });

  test('should return correct domain entity from model', () {
    final result = tWordDescriptionModel.toDomain();
    expect(result, equals(tWordDescriptionEntity));
  });
}
