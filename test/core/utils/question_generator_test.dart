import 'package:english_words_trainer/core/utils/questions_generator.dart';
import 'package:english_words_trainer/features/vocabulary/domain/entities/word_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'should return an empty array when words list less then 4 items',
    () {
      final tWordEntityList = [
        WordEntity(
          id: 1,
          userId: '123',
          englishWord: 'englishWord',
          translation: 'translation',
          meanings: const ['meaning1', 'meaning2'],
          createdAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
        ),
        WordEntity(
          id: 2,
          userId: '123',
          englishWord: 'englishWord2',
          translation: 'translation2',
          meanings: const ['meaning3', 'meaning4'],
          createdAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
        ),
      ];

      final result = generateQuestions(tWordEntityList);

      expect(result, equals(const []));
    },
  );

  test(
    'should return an empty array when no one of the words contains meanings',
    () {
      final tWordEntityList = [
        WordEntity(
          id: 1,
          userId: '123',
          englishWord: 'englishWord',
          translation: 'translation',
          meanings: const [],
          createdAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
        ),
        WordEntity(
          id: 2,
          userId: '123',
          englishWord: 'englishWord2',
          translation: 'translation2',
          meanings: const [],
          createdAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
        ),
        WordEntity(
          id: 4,
          userId: '123',
          englishWord: 'englishWord3',
          translation: 'translation3',
          meanings: const [],
          createdAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
        ),
        WordEntity(
          id: 5,
          userId: '123',
          englishWord: 'englishWord24',
          translation: 'translation24',
          meanings: const [],
          createdAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
        ),
      ];

      final result = generateQuestions(tWordEntityList);

      expect(result, equals(const []));
    },
  );

  test(
    'should return an array with number of wuestions equals to words with meanings',
    () {
      final tWordEntityList = [
        WordEntity(
          id: 1,
          userId: '123',
          englishWord: 'englishWord',
          translation: 'translation',
          meanings: const ['meaning1', 'meaning2'],
          createdAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
        ),
        WordEntity(
          id: 2,
          userId: '123',
          englishWord: 'englishWord2',
          translation: 'translation2',
          meanings: const [],
          createdAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
        ),
        WordEntity(
          id: 4,
          userId: '123',
          englishWord: 'englishWord3',
          translation: 'translation3',
          meanings: const ['meaning11', 'meaning22'],
          createdAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
        ),
        WordEntity(
          id: 5,
          userId: '123',
          englishWord: 'englishWord24',
          translation: 'translation24',
          meanings: const [],
          createdAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
        ),
      ];

      final result = generateQuestions(tWordEntityList);

      expect(result.length, 2);
    },
  );

  test(
    'returned question should have correct answer and three more options',
    () {
      final tWordEntityList = [
        WordEntity(
          id: 1,
          userId: '123',
          englishWord: 'englishWord',
          translation: 'translation',
          meanings: const [],
          createdAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
        ),
        WordEntity(
          id: 2,
          userId: '123',
          englishWord: 'englishWord2',
          translation: 'translation2',
          meanings: const [],
          createdAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
        ),
        WordEntity(
          id: 4,
          userId: '123',
          englishWord: 'englishWord3',
          translation: 'translation3',
          meanings: const ['meaning11', 'meaning22'],
          createdAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
        ),
        WordEntity(
          id: 5,
          userId: '123',
          englishWord: 'englishWord24',
          translation: 'translation24',
          meanings: const [],
          createdAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
        ),
        WordEntity(
          id: 5,
          userId: '123',
          englishWord: 'englishWord245',
          translation: 'translation245',
          meanings: const [],
          createdAt: DateTime.parse('2022-07-18T13:48:37.491701Z'),
        ),
      ];

      final result = generateQuestions(tWordEntityList);

      expect(result[0].answers.length, 4);
      expect(result[0].answers, contains('englishWord3'));
    },
  );
}
