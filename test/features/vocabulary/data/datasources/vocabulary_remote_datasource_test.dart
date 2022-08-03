import 'package:english_words_trainer/core/errors/exceptions.dart';
import 'package:english_words_trainer/features/vocabulary/data/datasources/vocabulary_remote_datasource.dart';
import 'package:english_words_trainer/features/vocabulary/data/models/word_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'mocks/vocabulary_remote_datasource_test.mocks.dart';

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
    const tCreatedWordResponse = {
      'id': 24,
      'createdAt': '2022-08-01T13:22:02.80902+00:00',
      'englishWord': 'cat',
      'translation': 'кот',
      'userId': tUserId,
    };

    final tExpectedResponse = WordModel.fromJson(tCreatedWordResponse);

    void setUpSuccessfullResponse() {
      when(mockSupabaseClient.from(any)).thenReturn(mockSupabaseQueryBuilder);
      when(mockSupabaseQueryBuilder.insert(any))
          .thenReturn(mockPostgrestBuilder);
      when(mockPostgrestBuilder.execute()).thenAnswer((_) async =>
          const PostgrestResponse(data: [tCreatedWordResponse], status: 201));
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

    test('should return WordModel when adding new word was successful', () async {
      setUpSuccessfullResponse();
      final result = await vocabularyRemoteDataSourceImpl.addNewWord(tNewWord);
      expect(result, equals(tExpectedResponse));
    });

    test('should return DataBaseException when status code is not 201',
        () async {
      setUpFailureResponse();

      final call = vocabularyRemoteDataSourceImpl.addNewWord;

      expect(() async => call(tNewWord),
          throwsA(const TypeMatcher<DataBaseException>()));
    });
  });

  group('getWordsList', () {
    const tWordsList = [
      {
        'id': 1,
        'englishWord': 'cat',
        'translation': 'кот',
        'userId': tUserId,
        'createdAt': '2022-07-27T09:58:52+00:00',
      },
      {
        'id': 2,
        'englishWord': 'dog',
        'translation': 'собака',
        'userId': tUserId,
        'createdAt': '2022-07-27T09:58:52+00:00',
      }
    ];

    final tWordsModelList = [
      WordModel(
        id: 1,
        userId: tUserId,
        englishWord: 'cat',
        translation: 'кот',
        createdAt: DateTime.parse('2022-07-27T09:58:52+00:00'),
      ),
      WordModel(
        id: 2,
        userId: tUserId,
        englishWord: 'dog',
        translation: 'собака',
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
          (_) async => const PostgrestResponse(data: tWordsList, status: 200));
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

      expect(() async => call(tUserId),
          throwsA(const TypeMatcher<DataBaseException>()));
    });
  });
}
