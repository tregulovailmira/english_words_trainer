import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/features/vocabulary/domain/repositories/vocabulary_repository.dart';
import 'package:english_words_trainer/features/vocabulary/domain/usecases/add_new_word.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'vocabulary_repository_test.mocks.dart';

@GenerateMocks([VocabularyRepository])
void main() {
  late AddNewWord usecase;
  late MockVocabularyRepository mockVocabularyRepository;

  setUp(() {
    mockVocabularyRepository = MockVocabularyRepository();
    usecase = AddNewWord(mockVocabularyRepository);
  });

  test('should return unit on adding new word calling repository', () async {
    const tUserId = 'testId';
    final tWord = {
      'userId': tUserId,
      'englishWord': 'test',
      'translation': 'тест',
    };
    when(mockVocabularyRepository.addNewWord(any))
        .thenAnswer((_) async => const Right(unit));

    final result = await usecase(Params(word: tWord));

    expect(result, equals(const Right(unit)));
    verify(mockVocabularyRepository.addNewWord(tWord));
    verifyNoMoreInteractions(mockVocabularyRepository);
  });
}
