import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/features/vocabulary/domain/entities/word_api_description_entity.dart';
import 'package:english_words_trainer/features/vocabulary/domain/repositories/word_description_repository.dart';
import 'package:english_words_trainer/features/vocabulary/domain/usecases/get_word_description.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './get_word_description_test.mocks.dart';

@GenerateMocks([WordDescriptionRepository])
void main() {
  late GetWordDescription usecase;
  late MockWordDescriptionRepository mockWordDescriptionRepository;

  setUp(() {
    mockWordDescriptionRepository = MockWordDescriptionRepository();
    usecase = GetWordDescription(mockWordDescriptionRepository);
  });

  test('should return WordEntity on adding new word calling repository',
      () async {
    const tWord = 'test';

    const tExpectedResponse = WordApiDescriptionEntity(
      word: tWord,
      meanings: ['test1', 'test2'],
      listeningUrl: 'https://test.com',
    );

    when(mockWordDescriptionRepository.getDescription(any))
        .thenAnswer((_) async => const Right(tExpectedResponse));

    final result = await usecase(const GetWordDescriptionParams(word: tWord));

    expect(result, equals(const Right(tExpectedResponse)));
    verify(mockWordDescriptionRepository.getDescription(tWord));
    verifyNoMoreInteractions(mockWordDescriptionRepository);
  });
}
