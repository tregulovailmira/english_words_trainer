import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/features/vocabulary/domain/entities/word_entity.dart';
import 'package:english_words_trainer/features/vocabulary/domain/repositories/vocabulary_repository.dart';
import 'package:english_words_trainer/features/vocabulary/domain/usecases/get_words_list.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/vocabulary_repository_test.mocks.dart';


@GenerateMocks([VocabularyRepository])
void main() {
  late GetWordsList usecase;
  late MockVocabularyRepository mockVocabularyRepository;

  setUp(() {
    mockVocabularyRepository = MockVocabularyRepository();
    usecase = GetWordsList(mockVocabularyRepository);
  });

  test('should return words list calling repository', () async {
    const tUserId = 'testId';
    final tWords = [
      WordEntity(
        userId: tUserId,
        createdAt: DateTime.now(),
        englishWord: 'test',
        id: 8,
        translation: 'тест',
      ),
      WordEntity(
        userId: tUserId,
        createdAt: DateTime.now(),
        englishWord: 'cat',
        id: 9,
        translation: 'кот',
      )
    ];
    when(mockVocabularyRepository.getWordsList(any))
        .thenAnswer((_) async => Right(tWords));

    final result = await usecase(const GetWordsParams(userId: tUserId));

    expect(result, equals(Right(tWords)));
    verify(mockVocabularyRepository.getWordsList(tUserId));
    verifyNoMoreInteractions(mockVocabularyRepository);
  });
}
