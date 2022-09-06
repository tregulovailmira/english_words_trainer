import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/features/vocabulary/domain/repositories/vocabulary_repository.dart';
import 'package:english_words_trainer/features/vocabulary/domain/usecases/delete_word.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './delete_word_test.mocks.dart';

@GenerateMocks([VocabularyRepository])
void main() {
  const tWordId = 5;

  late MockVocabularyRepository mockVocabularyRepository;
  late DeleteWord usecase;

  setUp(() {
    mockVocabularyRepository = MockVocabularyRepository();
    usecase = DeleteWord(mockVocabularyRepository);
  });

  test(
    'should return unit on word deleting caling repository',
    () async {
      when(mockVocabularyRepository.deleteWord(any))
          .thenAnswer((_) async => const Right(unit));

      final result = await usecase(const DeleteWordParams(id: tWordId));

      verify(mockVocabularyRepository.deleteWord(tWordId));
      expect(result, equals(const Right(unit)));
      verifyNoMoreInteractions(mockVocabularyRepository);
    },
  );
}
