import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/errors/failures.dart';
import 'package:english_words_trainer/features/vocabulary/domain/entities/word_entity.dart';
import 'package:english_words_trainer/features/vocabulary/domain/usecases/get_words_list.dart';
import 'package:english_words_trainer/features/vocabulary/presentation/bloc/words_list/words_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './words_list_bloc_test.mocks.dart';

@GenerateMocks([GetWordsList])
void main() {
  const tUserId = '12345';
  late MockGetWordsList mockGetWordsList;
  late WordsListBloc wordsListBloc;

  final tWordsList = [
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

  setUp(() {
    mockGetWordsList = MockGetWordsList();
    wordsListBloc = WordsListBloc(mockGetWordsList);
  });

  test('initial state should be empty', () {
    expect(wordsListBloc.state, equals(WordsListInitial()));
  });

  test(
    'should get words list via usecase',
    () async {
      when(mockGetWordsList(any)).thenAnswer((_) async => Right(tWordsList));
      wordsListBloc.add(const GetWordsEvent(tUserId));
      await untilCalled(mockGetWordsList(any));
      verify(mockGetWordsList(const Params(userId: tUserId)));
    },
  );

  test(
    'should emit [WordsListLoading, WordsListLoaded] when getting word was successful',
    () {
      when(mockGetWordsList(any)).thenAnswer((_) async => Right(tWordsList));
      final expectedStates = [
        WordsListLoading(),
        WordsListLoaded(words: tWordsList),
      ];

      expectLater(wordsListBloc.stream, emitsInOrder(expectedStates));

      wordsListBloc.add(const GetWordsEvent(tUserId));
    },
  );

  test(
    'should emit [WordsListLoading, WordsListError] when getting word was unsuccessful',
    () {
      when(mockGetWordsList(any))
          .thenAnswer((_) async => Left(DataBaseFailure(message: 'DB error')));
      final expectedStates = [
        WordsListLoading(),
        const WordsListError(message: 'DB error'),
      ];

      expectLater(wordsListBloc.stream, emitsInOrder(expectedStates));

      wordsListBloc.add(const GetWordsEvent(tUserId));
    },
  );

  test(
    'should emit WordsListLoaded with emplty list when user doesn\'t have words',
    () {
      when(mockGetWordsList(any)).thenAnswer((_) async => const Right([]));
      final expectedStates = [
        WordsListLoading(),
        const WordsListLoaded(words: []),
      ];

      expectLater(wordsListBloc.stream, emitsInOrder(expectedStates));

      wordsListBloc.add(const GetWordsEvent(tUserId));
    },
  );
}
