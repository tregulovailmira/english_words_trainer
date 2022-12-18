import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/features/vocabulary/domain/entities/word_entity.dart';
import 'package:english_words_trainer/features/vocabulary/domain/repositories/vocabulary_repository.dart';
import 'package:english_words_trainer/features/vocabulary/domain/usecases/add_new_word.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './add_new_word_test.mocks.dart';

@GenerateMocks([VocabularyRepository])
void main() {
  late AddNewWord usecase;
  late MockVocabularyRepository mockVocabularyRepository;

  setUp(() {
    mockVocabularyRepository = MockVocabularyRepository();
    usecase = AddNewWord(mockVocabularyRepository);
  });

  test(
    'should return WordEntity on adding new word calling repository',
    () async {
      const tUserId = 'testId';
      final tWord = {
        'userId': tUserId,
        'englishWord': 'test',
        'translation': 'тест',
      };

      final tExpectedResponse = WordEntity(
        englishWord: 'cat',
        translation: 'кот',
        id: 24,
        createdAt: DateTime.parse('2022-08-01T13:22:02.80902+00:00'),
        userId: tUserId,
        meanings: const [],
      );
      when(mockVocabularyRepository.addNewWord(any))
          .thenAnswer((_) async => Right(tExpectedResponse));

      final result = await usecase(AddNewWordParams(word: tWord));

      expect(result, equals(Right(tExpectedResponse)));
      verify(mockVocabularyRepository.addNewWord(tWord));
      verifyNoMoreInteractions(mockVocabularyRepository);
    },
  );
}
