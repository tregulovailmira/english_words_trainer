import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/errors/exceptions.dart';
import 'package:english_words_trainer/features/vocabulary/data/datasources/vocabulary_remote_datasource.dart';
import 'package:english_words_trainer/features/vocabulary/data/models/word_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './vocabulary_remote_datasource_test.mocks.dart';

@GenerateMocks([
  SupabaseClient,
  SupabaseQueryBuilder,
  PostgrestBuilder,
  PostgrestFilterBuilder
])
void main() {
  dotenv.testLoad(fileInput: "VOCABULARY_TABLE_NAME='vocabulary'");
  late MockSupabaseClient mockSupabaseClient;
  late MockSupabaseQueryBuilder mockSupabaseQueryBuilder;
  late MockPostgrestBuilder mockPostgrestBuilder;
  late MockPostgrestFilterBuilder postgrestFilterBuilder;
  late VocabularyRemoteDataSourceImpl vocabularyRemoteDataSourceImpl;

  const tUserId = '1234';

  const tWordResponse = {
    'id': 24,
    'createdAt': '2022-08-01T13:22:02.809020Z',
    'englishWord': 'cat',
    'translation': 'кот',
    'meanings': [],
    'listeningUrl': null,
    'userId': tUserId,
  };

  setUp(() {
    mockSupabaseClient = MockSupabaseClient();
    mockSupabaseQueryBuilder = MockSupabaseQueryBuilder();
    mockPostgrestBuilder = MockPostgrestBuilder();
    postgrestFilterBuilder = MockPostgrestFilterBuilder();
    vocabularyRemoteDataSourceImpl =
        VocabularyRemoteDataSourceImpl(client: mockSupabaseClient);
  });

  group('addNewWord', () {
    const tNewWord = {
      'englishWord': 'cat',
      'translation': 'кот',
      'userId': tUserId,
    };

    final tExpectedResponse = WordModel.fromJson(tWordResponse);

    void setUpSuccessfullResponse() {
      when(mockSupabaseClient.from(any)).thenReturn(mockSupabaseQueryBuilder);
      when(mockSupabaseQueryBuilder.insert(any))
          .thenReturn(mockPostgrestBuilder);
      when(mockPostgrestBuilder.execute()).thenAnswer(
        (_) async => const PostgrestResponse(
          data: [tWordResponse],
          status: 201,
        ),
      );
    }

    void setUpFailureResponse() {
      when(mockSupabaseClient.from(any)).thenReturn(mockSupabaseQueryBuilder);
      when(mockSupabaseQueryBuilder.insert(any))
          .thenReturn(mockPostgrestBuilder);
      when(mockPostgrestBuilder.execute()).thenAnswer(
        (_) async => PostgrestResponse(
          data: null,
          status: 400,
          error: PostgrestError(message: 'DB Error'),
        ),
      );
    }

    test('should call insert method of the Supabase client ', () async {
      // arrange
      setUpSuccessfullResponse();

      // act
      vocabularyRemoteDataSourceImpl.addNewWord(tNewWord);

      // assert
      verify(mockSupabaseClient.from('vocabulary'));
      verify(mockSupabaseQueryBuilder.insert(tNewWord));
      verify(mockPostgrestBuilder.execute());
      verifyNoMoreInteractions(mockSupabaseClient);
      verifyNoMoreInteractions(mockSupabaseQueryBuilder);
      verifyNoMoreInteractions(mockPostgrestBuilder);
    });

    test('should return WordModel when adding new word was successful',
        () async {
      setUpSuccessfullResponse();
      final result = await vocabularyRemoteDataSourceImpl.addNewWord(tNewWord);
      expect(result, equals(tExpectedResponse));
    });

    test('should return DataBaseException when status code is not 201',
        () async {
      setUpFailureResponse();

      final call = vocabularyRemoteDataSourceImpl.addNewWord;

      expect(
        () async => call(tNewWord),
        throwsA(const TypeMatcher<DataBaseException>()),
      );
    });
  });

  group('getWordsList', () {
    const tWordsList = [
      {
        'id': 1,
        'englishWord': 'cat',
        'translation': 'кот',
        'userId': tUserId,
        'meanings': [],
        'createdAt': '2022-07-27T09:58:52+00:00',
      },
      {
        'id': 2,
        'englishWord': 'dog',
        'translation': 'собака',
        'userId': tUserId,
        'meanings': [],
        'createdAt': '2022-07-27T09:58:52+00:00',
      }
    ];

    final tWordsModelList = [
      WordModel(
        id: 1,
        userId: tUserId,
        englishWord: 'cat',
        translation: 'кот',
        meanings: const [],
        createdAt: DateTime.parse('2022-07-27T09:58:52+00:00'),
      ),
      WordModel(
        id: 2,
        userId: tUserId,
        englishWord: 'dog',
        translation: 'собака',
        meanings: const [],
        createdAt: DateTime.parse('2022-07-27T09:58:52+00:00'),
      )
    ];
    void setUpSuccessfullResponse() {
      when(mockSupabaseClient.from(any)).thenReturn(mockSupabaseQueryBuilder);
      when(mockSupabaseQueryBuilder.select())
          .thenReturn(postgrestFilterBuilder);
      when(postgrestFilterBuilder.filter('userId', 'eq', tUserId))
          .thenReturn(postgrestFilterBuilder);
      when(postgrestFilterBuilder.execute()).thenAnswer(
        (_) async => const PostgrestResponse(
          data: tWordsList,
          status: 200,
        ),
      );
    }

    void setUpFailureResponse() {
      when(mockSupabaseClient.from(any)).thenReturn(mockSupabaseQueryBuilder);
      when(mockSupabaseQueryBuilder.select())
          .thenReturn(postgrestFilterBuilder);
      when(postgrestFilterBuilder.filter('userId', 'eq', tUserId))
          .thenReturn(postgrestFilterBuilder);
      when(postgrestFilterBuilder.execute()).thenAnswer(
        (_) async => PostgrestResponse(
          data: null,
          status: 400,
          error: PostgrestError(message: 'DB Error'),
        ),
      );
    }

    test('should call select method of the Supabase client ', () async {
      // arrange
      setUpSuccessfullResponse();

      // act
      vocabularyRemoteDataSourceImpl.getListWords(tUserId);

      // assert
      verify(mockSupabaseClient.from('vocabulary'));
      verify(mockSupabaseQueryBuilder.select());
      verify(postgrestFilterBuilder.filter('userId', 'eq', tUserId));
      verify(postgrestFilterBuilder.execute());
      verifyNoMoreInteractions(mockSupabaseClient);
      verifyNoMoreInteractions(mockSupabaseQueryBuilder);
      verifyNoMoreInteractions(postgrestFilterBuilder);
    });

    test('should return unit when adding new word was successful', () async {
      setUpSuccessfullResponse();
      final result = await vocabularyRemoteDataSourceImpl.getListWords(tUserId);
      expect(result, equals(tWordsModelList));
    });

    test('should return DataBaseException when status code is not 201',
        () async {
      setUpFailureResponse();

      final call = vocabularyRemoteDataSourceImpl.getListWords;

      expect(
        () async => call(tUserId),
        throwsA(const TypeMatcher<DataBaseException>()),
      );
    });
  });

  group('updateWord', () {
    void setUpPosgresBuilder() {
      when(mockSupabaseClient.from(any)).thenReturn(mockSupabaseQueryBuilder);
      when(mockSupabaseQueryBuilder.update(any))
          .thenReturn(postgrestFilterBuilder);
      when(postgrestFilterBuilder.match(any))
          .thenReturn(postgrestFilterBuilder);
    }

    void setUpSuccessfullResponse() {
      when(postgrestFilterBuilder.execute()).thenAnswer(
        (_) async => const PostgrestResponse(
          data: [tWordResponse],
          status: 200,
        ),
      );
    }

    void setUpFailureResponse() {
      when(postgrestFilterBuilder.execute()).thenAnswer(
        (_) async => PostgrestResponse(
          data: null,
          status: 400,
          error: PostgrestError(message: 'DB Error'),
        ),
      );
    }

    test(
      'should call update method of the Supabase client',
      () async {
        setUpPosgresBuilder();
        setUpSuccessfullResponse();

        vocabularyRemoteDataSourceImpl
            .updateWord(WordModel.fromJson(tWordResponse));

        // assert
        verify(mockSupabaseClient.from('vocabulary'));
        verify(
          mockSupabaseQueryBuilder.update(tWordResponse),
        );
        verify(postgrestFilterBuilder.match({'id': tWordResponse['id']}));
        verify(postgrestFilterBuilder.execute());
        verifyNoMoreInteractions(mockSupabaseClient);
        verifyNoMoreInteractions(mockSupabaseQueryBuilder);
        verifyNoMoreInteractions(postgrestFilterBuilder);
      },
    );

    test(
      'should return word model when word updating was successful',
      () async {
        setUpPosgresBuilder();
        setUpSuccessfullResponse();

        final result = await vocabularyRemoteDataSourceImpl
            .updateWord(WordModel.fromJson(tWordResponse));

        expect(result, equals(WordModel.fromJson(tWordResponse)));
      },
    );

    test(
      'should throw DataBaseException when status code is not 200',
      () async {
        setUpPosgresBuilder();
        setUpFailureResponse();

        final call = vocabularyRemoteDataSourceImpl.updateWord;

        expect(
          () async => await call((WordModel.fromJson(tWordResponse))),
          throwsA(const TypeMatcher<DataBaseException>()),
        );
      },
    );
  });

  group('deleteWord', () {
    const tWordId = 5;

    void setUpPosgresBuilder() {
      when(mockSupabaseClient.from(any)).thenReturn(mockSupabaseQueryBuilder);
      when(mockSupabaseQueryBuilder.delete())
          .thenReturn(postgrestFilterBuilder);
      when(postgrestFilterBuilder.match(any))
          .thenReturn(postgrestFilterBuilder);
    }

    void setUpSuccessfullResponse() {
      when(postgrestFilterBuilder.execute()).thenAnswer(
        (_) async => const PostgrestResponse(
          data: [tWordResponse],
          status: 200,
        ),
      );
    }

    void setUpFailureResponse() {
      when(postgrestFilterBuilder.execute()).thenAnswer(
        (_) async => PostgrestResponse(
          data: null,
          status: 400,
          error: PostgrestError(message: 'DB Error'),
        ),
      );
    }

    test(
      'should call delete method of the Supabase client',
      () async {
        setUpPosgresBuilder();
        setUpSuccessfullResponse();

        vocabularyRemoteDataSourceImpl.deleteWord(tWordId);

        verify(mockSupabaseClient.from('vocabulary'));
        verify(
          mockSupabaseQueryBuilder.delete(),
        );
        verify(postgrestFilterBuilder.match({'id': tWordId}));
        verify(postgrestFilterBuilder.execute());
        verifyNoMoreInteractions(mockSupabaseClient);
        verifyNoMoreInteractions(mockSupabaseQueryBuilder);
        verifyNoMoreInteractions(postgrestFilterBuilder);
      },
    );

    test(
      'should return unit model when word deleting was successful',
      () async {
        setUpPosgresBuilder();
        setUpSuccessfullResponse();

        final result = await vocabularyRemoteDataSourceImpl.deleteWord(tWordId);

        expect(result, equals(unit));
      },
    );

    test(
      'should throw DataBaseException when status code is not 200',
      () async {
        setUpPosgresBuilder();
        setUpFailureResponse();

        final call = vocabularyRemoteDataSourceImpl.deleteWord;

        expect(
          () async => await call(tWordId),
          throwsA(const TypeMatcher<DataBaseException>()),
        );
      },
    );
  });
}
