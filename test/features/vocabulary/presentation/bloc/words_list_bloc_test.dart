import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/errors/failures.dart';
import 'package:english_words_trainer/features/vocabulary/domain/entities/word_entity.dart';
import 'package:english_words_trainer/features/vocabulary/domain/usecases/add_new_word.dart';
import 'package:english_words_trainer/features/vocabulary/domain/usecases/get_words_list.dart';
import 'package:english_words_trainer/features/vocabulary/presentation/bloc/words_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'words_list_bloc_test.mocks.dart';

@GenerateMocks([GetWordsList, AddNewWord])
void main() {
  const tUserId = '12345';
  late MockGetWordsList mockGetWordsList;
  late MockAddNewWord mockAddNewWord;
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
    mockAddNewWord = MockAddNewWord();
    wordsListBloc = WordsListBloc(
        getWordsList: mockGetWordsList, addNewWord: mockAddNewWord);
  });

  test('initial state should be empty', () {
    expect(wordsListBloc.state, equals(const WordsListState()));
  });

  group('getWordsList', () {
    test(
      'should get words list via usecase',
      () async {
        when(mockGetWordsList(any)).thenAnswer((_) async => Right(tWordsList));
        wordsListBloc.add(const GetWordsEvent(tUserId));
        await untilCalled(mockGetWordsList(any));
        verify(mockGetWordsList(const GetWordsParams(userId: tUserId)));
      },
    );

    test(
      'should emit state in correct order when getting word was successful',
      () {
        when(mockGetWordsList(any)).thenAnswer((_) async => Right(tWordsList));
        final expectedStates = [
          const WordsListState(isLoading: true, isError: false, words: []),
          WordsListState(isLoading: false, words: tWordsList, isError: false),
        ];

        expectLater(wordsListBloc.stream, emitsInOrder(expectedStates));

        wordsListBloc.add(const GetWordsEvent(tUserId));
      },
    );

    test(
      'should emit state in correct order when getting word was unsuccessful',
      () {
        when(mockGetWordsList(any)).thenAnswer(
            (_) async => Left(DataBaseFailure(message: 'DB error')));
        final expectedStates = [
          const WordsListState(isLoading: true, isError: false, words: []),
          const WordsListState(
              isError: true,
              isLoading: false,
              errorMessage: 'DB error',
              words: []),
        ];

        expectLater(wordsListBloc.stream, emitsInOrder(expectedStates));

        wordsListBloc.add(const GetWordsEvent(tUserId));
      },
    );

    test(
      'should emit state with empty list when user doesn\'t have words',
      () {
        when(mockGetWordsList(any)).thenAnswer((_) async => const Right([]));
        final expectedStates = [
          const WordsListState(isLoading: true, isError: false, words: []),
          const WordsListState(words: [], isError: false, isLoading: false),
        ];

        expectLater(wordsListBloc.stream, emitsInOrder(expectedStates));

        wordsListBloc.add(const GetWordsEvent(tUserId));
      },
    );
  });

  group('addNewWord', () {
    const tNewWord = {
      'userId': tUserId,
      'englishWord': 'test',
      'translation': 'тест',
    };
    final tCreatedWord = WordEntity(
      englishWord: 'test',
      translation: 'тест',
      id: 24,
      createdAt: DateTime.parse('2022-08-01T13:22:02.80902+00:00'),
      userId: tUserId,
    );

    final tUpdatedWordsList = [...tWordsList, tCreatedWord];
    test(
      'should add word via usecase',
      () async {
        when(mockAddNewWord(any)).thenAnswer((_) async => Right(tCreatedWord));
        wordsListBloc.add(const AddWordEvent(tNewWord));
        await untilCalled(mockAddNewWord(any));
        verify(mockAddNewWord(const AddNewWordParams(word: tNewWord)));
      },
    );

    test(
      'should emit state in correct order when adding word was successful',
      () {
        when(mockGetWordsList(any)).thenAnswer((_) async => Right(tWordsList));
        when(mockAddNewWord(any)).thenAnswer((_) async => Right(tCreatedWord));
        final expectedStates = [
          const WordsListState(isLoading: true, isError: false, words: []),
          WordsListState(isLoading: false, words: tWordsList, isError: false),
          WordsListState(isLoading: true, isError: false, words: tWordsList),
          WordsListState(
              isLoading: false, isError: false, words: tUpdatedWordsList),
        ];

        expectLater(wordsListBloc.stream, emitsInOrder(expectedStates));

        wordsListBloc.add(const GetWordsEvent(tUserId));
        wordsListBloc.add(const AddWordEvent(tNewWord));
      },
    );

    test(
      'should emit state in correct order when adding word was unsuccessful',
      () {
        when(mockGetWordsList(any)).thenAnswer((_) async => Right(tWordsList));
        when(mockAddNewWord(any)).thenAnswer(
            (_) async => Left(DataBaseFailure(message: 'DB error')));
        final expectedStates = [
          const WordsListState(isLoading: true, isError: false, words: []),
          WordsListState(isLoading: false, words: tWordsList, isError: false),
          WordsListState(isLoading: true, isError: false, words: tWordsList),
          WordsListState(
              isLoading: false,
              isError: true,
              words: tWordsList,
              errorMessage: 'DB error'),
        ];

        expectLater(wordsListBloc.stream, emitsInOrder(expectedStates));

        wordsListBloc.add(const GetWordsEvent(tUserId));
        wordsListBloc.add(const AddWordEvent(tNewWord));
      },
    );
  });
}
