import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/features/vocabulary/domain/entities/word_entity.dart';
import 'package:english_words_trainer/features/vocabulary/domain/repositories/vocabulary_repository.dart';
import 'package:english_words_trainer/features/vocabulary/domain/usecases/update_word.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/vocabulary_repository_test.mocks.dart';

@GenerateMocks([VocabularyRepository])
void main() {
  late MockVocabularyRepository mockVocabularyRepository;
  late UpdateWord usecase;

  final tWordEntity = WordEntity(
    id: 5,
    englishWord: 'cat',
    translation: 'кот',
    userId: '123',
    meanings: const [],
    createdAt: DateTime.parse('2022-07-29T12:06:28+00:00'),
  );

  setUp(() {
    mockVocabularyRepository = MockVocabularyRepository();
    usecase = UpdateWord(mockVocabularyRepository);
  });

  test('should return WordEntity on update word calling repository', () async {
    when(mockVocabularyRepository.updateWord(any)).thenAnswer(
      (_) async => Right(tWordEntity),
    );

    final result = await usecase(UpdateWordParams(word: tWordEntity));

    verify(mockVocabularyRepository.updateWord(tWordEntity));
    expect(result, equals(Right(tWordEntity)));
    verifyNoMoreInteractions(mockVocabularyRepository);
  });
}
