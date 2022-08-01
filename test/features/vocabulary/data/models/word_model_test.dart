import 'package:english_words_trainer/features/vocabulary/data/models/word_model.dart';
import 'package:english_words_trainer/features/vocabulary/domain/entities/word_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tDateString = '2022-07-27T09:58:52+00:00';
  final tWord = WordModel(
    id: 123,
    userId: '345',
    englishWord: 'cat',
    translation: 'кот',
    createdAt: DateTime.parse(tDateString),
  );

  test('should be a subclass of WordEntity', () {
    expect(tWord, isA<WordEntity>());
  });

  test('should return a valid model from Map', () {
    final tMapWordResponse = {
      'id': 123,
      'userId': '345',
      'englishWord': 'cat',
      'translation': 'кот',
      'createdAt': tDateString,
    };
    final result = WordModel.fromMap(tMapWordResponse);
    expect(result, equals(tWord));
  });

  test('should return valid Map from WordModel', () {
    final tMapWordRequest = {
      'id': 123,
      'userId': '345',
      'englishWord': 'cat',
      'translation': 'кот',
    };
    final result = tWord.toMap();
    expect(result, equals(tMapWordRequest));
  });
}
