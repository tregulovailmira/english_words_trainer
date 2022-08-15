import 'package:english_words_trainer/features/vocabulary/data/models/word_model.dart';
import 'package:english_words_trainer/features/vocabulary/domain/entities/word_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tDateString = '2022-07-27T09:58:52+00:00';
  final tWordModel = WordModel(
    id: 123,
    userId: '345',
    englishWord: 'cat',
    translation: 'кот',
    meanings: const [],
    createdAt: DateTime.parse(tDateString),
  );
  final tWordEntity = WordEntity(
    id: 123,
    userId: '345',
    englishWord: 'cat',
    translation: 'кот',
    meanings: const [],
    createdAt: DateTime.parse(tDateString),
  );

  test('should return valid WordModel from WordEntity', () {
    final result = WordModel.fromDomain(tWordEntity);
    expect(result, equals(tWordModel));
  });

    test('should return valid WordEntity from WordModel', () {
    final result = tWordModel.toDomain();
    expect(result, equals(tWordEntity));
  });
}
