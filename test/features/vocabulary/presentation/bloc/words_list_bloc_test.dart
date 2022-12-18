import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/errors/failures.dart';
import 'package:english_words_trainer/features/vocabulary/domain/entities/word_api_description_entity.dart';
import 'package:english_words_trainer/features/vocabulary/domain/entities/word_entity.dart';
import 'package:english_words_trainer/features/vocabulary/domain/usecases/add_new_word.dart';
import 'package:english_words_trainer/features/vocabulary/domain/usecases/delete_word.dart';
import 'package:english_words_trainer/features/vocabulary/domain/usecases/get_word_description.dart';
import 'package:english_words_trainer/features/vocabulary/domain/usecases/get_words_list.dart';
import 'package:english_words_trainer/features/vocabulary/domain/usecases/update_word.dart';
import 'package:english_words_trainer/features/vocabulary/presentation/bloc/words_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './words_list_bloc_test.mocks.dart';

@GenerateMocks([
  GetWordsList,
  AddNewWord,
  UpdateWord,
  DeleteWord,
  GetWordDescription,
])
void main() {
  const tUserId = '12345';
  const tWordId = 8;
  late MockGetWordsList mockGetWordsList;
  late MockAddNewWord mockAddNewWord;
  late MockUpdateWord mockUpdateWord;
  late MockDeleteWord mockDeleteWord;
  late MockGetWordDescription mockGetWordDescription;
  late WordsListBloc wordsListBloc;

  final tWordsList = [
    WordEntity(
      userId: tUserId,
      createdAt: DateTime.parse('2022-08-01T13:22:02.80902+00:00'),
      englishWord: 'test',
      id: 8,
      translation: 'тест',
      meanings: const [],
    ),
    WordEntity(
      userId: tUserId,
      createdAt: DateTime.parse('2022-08-01T13:22:02.80902+00:00'),
      englishWord: 'cat',
      id: 9,
      translation: 'кот',
      meanings: const [],
    )
  ];

  const tWordDescription = WordApiDescriptionEntity(
    word: 'test',
    meanings: ['test1', 'test2'],
  );

  setUp(() {
    mockGetWordsList = MockGetWordsList();
    mockAddNewWord = MockAddNewWord();
    mockUpdateWord = MockUpdateWord();
    mockDeleteWord = MockDeleteWord();
    mockGetWordDescription = MockGetWordDescription();
    wordsListBloc = WordsListBloc(
      getWordsList: mockGetWordsList,
      addNewWord: mockAddNewWord,
      updateWord: mockUpdateWord,
      deleteWord: mockDeleteWord,
      getWordDescription: mockGetWordDescription,
    );
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
          (_) async => Left(DataBaseFailure(message: 'DB error')),
        );
        final expectedStates = [
          const WordsListState(isLoading: true, isError: false, words: []),
          const WordsListState(
            isError: true,
            isLoading: false,
            errorMessage: 'DB error',
            words: [],
          ),
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
    final tNewWord = {
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
      meanings: tWordDescription.meanings,
      listeningUrl: tWordDescription.listeningUrl,
    );

    final tUpdatedWordsList = [...tWordsList, tCreatedWord];
    test(
      'should add word via usecase',
      () async {
        when(mockGetWordDescription(any))
            .thenAnswer((_) async => const Right(tWordDescription));
        when(mockAddNewWord(any)).thenAnswer((_) async => Right(tCreatedWord));

        wordsListBloc.add(AddWordEvent(tNewWord));

        await untilCalled(mockGetWordDescription(any));
        await untilCalled(mockAddNewWord(any));

        verify(
          mockAddNewWord(
            AddNewWordParams(
              word: {
                ...tNewWord,
                'listeningUrl': tWordDescription.listeningUrl,
                'meanings': tWordDescription.meanings,
              },
            ),
          ),
        );
        verify(
          mockGetWordDescription(const GetWordDescriptionParams(word: 'test')),
        );
      },
    );

    test(
      'should emit state in correct order when adding word was successful',
      () {
        when(mockGetWordsList(any)).thenAnswer((_) async => Right(tWordsList));
        when(mockGetWordDescription(any))
            .thenAnswer((_) async => const Right(tWordDescription));
        when(mockAddNewWord(any)).thenAnswer((_) async => Right(tCreatedWord));
        final expectedStates = [
          const WordsListState(isLoading: true, isError: false, words: []),
          WordsListState(isLoading: false, words: tWordsList, isError: false),
          WordsListState(isLoading: true, isError: false, words: tWordsList),
          WordsListState(
            isLoading: false,
            isError: false,
            words: tUpdatedWordsList,
          ),
        ];

        expectLater(wordsListBloc.stream, emitsInOrder(expectedStates));

        wordsListBloc.add(const GetWordsEvent(tUserId));
        wordsListBloc.add(AddWordEvent(tNewWord));
      },
    );

    test(
      'should emit state in correct order when adding word was unsuccessful',
      () {
        when(mockGetWordsList(any)).thenAnswer((_) async => Right(tWordsList));
        when(mockGetWordDescription(any))
            .thenAnswer((_) async => const Right(tWordDescription));
        when(mockAddNewWord(any)).thenAnswer(
          (_) async => Left(DataBaseFailure(message: 'DB error')),
        );
        final expectedStates = [
          const WordsListState(isLoading: true, isError: false, words: []),
          WordsListState(isLoading: false, words: tWordsList, isError: false),
          WordsListState(isLoading: true, isError: false, words: tWordsList),
          WordsListState(
            isLoading: false,
            isError: true,
            words: tWordsList,
            errorMessage: 'DB error',
          ),
        ];

        expectLater(wordsListBloc.stream, emitsInOrder(expectedStates));

        wordsListBloc.add(const GetWordsEvent(tUserId));
        wordsListBloc.add(AddWordEvent(tNewWord));
      },
    );

    test(
      'should emit state in correct order when getting word description was unsuccessful',
      () {
        final tCreatedWordWithoutDescription = WordEntity(
          englishWord: 'test',
          translation: 'тест',
          id: 24,
          createdAt: DateTime.parse('2022-08-01T13:22:02.80902+00:00'),
          userId: tUserId,
          meanings: tWordDescription.meanings,
          listeningUrl: tWordDescription.listeningUrl,
        );

        when(mockGetWordsList(any)).thenAnswer((_) async => Right(tWordsList));
        when(mockGetWordDescription(any)).thenAnswer(
          (_) async => Left(ApiFailure(message: 'Word not found')),
        );
        when(mockAddNewWord(any)).thenAnswer(
          (_) async => Right(tCreatedWordWithoutDescription),
        );

        final expectedStates = [
          const WordsListState(isLoading: true),
          WordsListState(isLoading: false, words: tWordsList),
          WordsListState(isLoading: true, words: tWordsList),
          WordsListState(
            isLoading: false,
            words: [
              ...tWordsList,
              tCreatedWordWithoutDescription,
            ],
          ),
        ];

        expectLater(wordsListBloc.stream, emitsInOrder(expectedStates));

        wordsListBloc.add(const GetWordsEvent(tUserId));
        wordsListBloc.add(AddWordEvent(tNewWord));
      },
    );
  });

  group('updateWord', () {
    const tUpdatedEnglishWord = 'test';
    const tUpdatedTranslation = 'тест';

    final tUpdatedWord = WordEntity(
      englishWord: tUpdatedEnglishWord,
      translation: tUpdatedTranslation,
      id: 8,
      createdAt: DateTime.parse('2022-08-01T13:22:02.80902+00:00'),
      userId: tUserId,
      meanings: tWordDescription.meanings,
      listeningUrl: tWordDescription.listeningUrl,
    );

    final tUpdatedWordsList = [tUpdatedWord, tWordsList[1]];
    test(
      'should update word via usecase',
      () async {
        when(mockGetWordsList(any)).thenAnswer((_) async => Right(tWordsList));
        when(mockGetWordDescription(any))
            .thenAnswer((_) async => const Right(tWordDescription));
        when(mockUpdateWord(any)).thenAnswer((_) async => Right(tUpdatedWord));
        wordsListBloc.add(const GetWordsEvent(tUserId));
        wordsListBloc.add(
          const UpdateWordEvent(
            id: tWordId,
            updatedEnglishWord: tUpdatedEnglishWord,
            updatedTranslation: tUpdatedTranslation,
          ),
        );
        await untilCalled(mockUpdateWord(any));

        verify(mockUpdateWord(UpdateWordParams(word: tUpdatedWord)));
        verify(
          mockGetWordDescription(const GetWordDescriptionParams(word: 'test')),
        );
      },
    );

    test(
      'should emit state in correct order when updating word was successful',
      () {
        when(mockGetWordsList(any)).thenAnswer((_) async => Right(tWordsList));
        when(mockGetWordDescription(any))
            .thenAnswer((_) async => const Right(tWordDescription));
        when(mockUpdateWord(any)).thenAnswer((_) async => Right(tUpdatedWord));

        final expectedStates = [
          const WordsListState(isLoading: true),
          WordsListState(isLoading: false, words: tWordsList),
          WordsListState(isLoading: true, words: tWordsList),
          WordsListState(isLoading: false, words: tUpdatedWordsList),
        ];

        expectLater(wordsListBloc.stream, emitsInOrder(expectedStates));

        wordsListBloc.add(const GetWordsEvent(tUserId));
        wordsListBloc.add(
          const UpdateWordEvent(
            id: tWordId,
            updatedEnglishWord: tUpdatedEnglishWord,
            updatedTranslation: tUpdatedTranslation,
          ),
        );
      },
    );

    test(
      'should emit state in correct order when updating word was unsuccessful',
      () {
        when(mockGetWordsList(any)).thenAnswer((_) async => Right(tWordsList));
        when(mockGetWordDescription(any))
            .thenAnswer((_) async => const Right(tWordDescription));
        when(mockUpdateWord(any)).thenAnswer(
          (_) async => Left(DataBaseFailure(message: 'DB error')),
        );

        final expectedStates = [
          const WordsListState(isLoading: true),
          WordsListState(isLoading: false, words: tWordsList),
          WordsListState(isLoading: true, words: tWordsList),
          WordsListState(
            isLoading: false,
            isError: true,
            errorMessage: 'DB error',
            words: tWordsList,
          ),
        ];

        expectLater(wordsListBloc.stream, emitsInOrder(expectedStates));

        wordsListBloc.add(const GetWordsEvent(tUserId));
        wordsListBloc.add(
          const UpdateWordEvent(
            id: tWordId,
            updatedEnglishWord: tUpdatedEnglishWord,
            updatedTranslation: tUpdatedTranslation,
          ),
        );
      },
    );

    test(
      'should emit state in correct order when getting word description was unsuccessful',
      () {
        final tUpdatedWordWithoutDescription = WordEntity(
          englishWord: tUpdatedEnglishWord,
          translation: tUpdatedTranslation,
          id: 8,
          createdAt: DateTime.parse('2022-08-01T13:22:02.80902+00:00'),
          userId: tUserId,
          meanings: const [],
          listeningUrl: null,
        );
        when(mockGetWordsList(any)).thenAnswer((_) async => Right(tWordsList));
        when(mockGetWordDescription(any)).thenAnswer(
          (_) async => Left(ApiFailure(message: 'Word not found')),
        );
        when(mockUpdateWord(any)).thenAnswer(
          (_) async => Right(tUpdatedWordWithoutDescription),
        );

        final expectedStates = [
          const WordsListState(isLoading: true),
          WordsListState(isLoading: false, words: tWordsList),
          WordsListState(isLoading: true, words: tWordsList),
          WordsListState(
            isLoading: false,
            words: [tUpdatedWordWithoutDescription, tWordsList[1]],
          ),
        ];

        expectLater(wordsListBloc.stream, emitsInOrder(expectedStates));

        wordsListBloc.add(const GetWordsEvent(tUserId));
        wordsListBloc.add(
          const UpdateWordEvent(
            id: tWordId,
            updatedEnglishWord: tUpdatedEnglishWord,
            updatedTranslation: tUpdatedTranslation,
          ),
        );
      },
    );
  });

  group('deleteWord', () {
    test(
      'should delete word via usecase',
      () async {
        when(mockGetWordsList(any)).thenAnswer((_) async => Right(tWordsList));
        when(mockDeleteWord(any)).thenAnswer((_) async => const Right(unit));
        wordsListBloc.add(const GetWordsEvent(tUserId));
        wordsListBloc.add(const DeleteWordEvent(tWordId));
        await untilCalled(mockDeleteWord(any));

        verify(mockDeleteWord(const DeleteWordParams(id: tWordId)));
      },
    );

    test(
      'should emit state in correct order when deleting word was successful',
      () {
        when(mockGetWordsList(any)).thenAnswer((_) async => Right(tWordsList));
        when(mockDeleteWord(any)).thenAnswer((_) async => const Right(unit));

        final expectedStates = [
          const WordsListState(isLoading: true),
          WordsListState(isLoading: false, words: tWordsList),
          WordsListState(isLoading: true, words: tWordsList),
          WordsListState(isLoading: false, words: [tWordsList[1]]),
        ];

        expectLater(wordsListBloc.stream, emitsInOrder(expectedStates));

        wordsListBloc.add(const GetWordsEvent(tUserId));
        wordsListBloc.add(const DeleteWordEvent(tWordId));
      },
    );

    test(
      'should emit state in correct order when deleting word was unsuccessful',
      () {
        when(mockGetWordsList(any)).thenAnswer((_) async => Right(tWordsList));
        when(mockDeleteWord(any)).thenAnswer(
          (_) async => Left(DataBaseFailure(message: 'DB error')),
        );

        final expectedStates = [
          const WordsListState(isLoading: true),
          WordsListState(isLoading: false, words: tWordsList),
          WordsListState(isLoading: true, words: tWordsList),
          WordsListState(
            isLoading: false,
            isError: true,
            errorMessage: 'DB error',
            words: tWordsList,
          ),
        ];

        expectLater(wordsListBloc.stream, emitsInOrder(expectedStates));

        wordsListBloc.add(const GetWordsEvent(tUserId));
        wordsListBloc.add(const DeleteWordEvent(tWordId));
      },
    );
  });
}
