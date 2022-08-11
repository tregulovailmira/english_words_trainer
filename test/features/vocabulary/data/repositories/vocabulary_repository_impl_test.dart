import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/errors/exceptions.dart';
import 'package:english_words_trainer/core/errors/failures.dart';
import 'package:english_words_trainer/features/vocabulary/data/datasources/vocabulary_remote_datasource.dart';
import 'package:english_words_trainer/features/vocabulary/data/models/word_model.dart';
import 'package:english_words_trainer/features/vocabulary/data/repositories/vocabulary_repository_impl.dart';
import 'package:english_words_trainer/features/vocabulary/domain/entities/word_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './mocks/vocabulary_repository_impl_test.mocks.dart';

@GenerateMocks([VocabularyRemoteDataSource])
void main() {
  late MockVocabularyRemoteDataSource mockVocabularyRemoteDataSource;
  late VocabularyRepositoryImpl vocabularyRepositoryImpl;

  setUp(() {
    mockVocabularyRemoteDataSource = MockVocabularyRemoteDataSource();
    vocabularyRepositoryImpl =
        VocabularyRepositoryImpl(mockVocabularyRemoteDataSource);
  });

  group('addNewWord', () {
    const tUserId = '12345';
    const tNewWord = {
      'englishWord': 'cat',
      'translation': 'кот',
      'userId': tUserId,
    };

    final tExpectedResponse = WordModel(
      englishWord: 'cat',
      translation: 'кот',
      id: 24,
      createdAt: DateTime.parse('2022-08-01T13:22:02.80902+00:00'),
      userId: tUserId,
    );
    test('should retrun WordEntity when adding new word was successful',
        () async {
      when(mockVocabularyRemoteDataSource.addNewWord(any))
          .thenAnswer((_) async => tExpectedResponse);

      final result = await vocabularyRepositoryImpl.addNewWord(tNewWord);

      verify(mockVocabularyRemoteDataSource.addNewWord(tNewWord));
      expect(result, equals(Right(tExpectedResponse.toDomain())));
    });

    test('should return DataBaseFailure if adding new word was unsuccessful',
        () async {
      when(mockVocabularyRemoteDataSource.addNewWord(any))
          .thenThrow(DataBaseException('DB error', 400));
      final result = await vocabularyRepositoryImpl.addNewWord(tNewWord);

      expect(
        result,
        equals(Left(DataBaseFailure(message: 'DB error', statusCode: 400))),
      );
    });
  });

  group('getWordsList', () {
    const tUserId = '12344';
    final tWordsModelListFromDataSource = [
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

    final tEpectedResponse = [
      WordEntity(
        id: 1,
        userId: tUserId,
        englishWord: 'cat',
        translation: 'кот',
        createdAt: DateTime.parse('2022-07-27T09:58:52+00:00'),
      ),
      WordEntity(
        id: 2,
        userId: tUserId,
        englishWord: 'dog',
        translation: 'собака',
        createdAt: DateTime.parse('2022-07-27T09:58:52+00:00'),
      )
    ];
    test('should retrun WordEntity when getting words was successful',
        () async {
      when(mockVocabularyRemoteDataSource.getListWords(any))
          .thenAnswer((_) async => tWordsModelListFromDataSource);

      final result = await vocabularyRepositoryImpl.getWordsList(tUserId);

      verify(mockVocabularyRemoteDataSource.getListWords(tUserId));
      result.fold((left) => fail('test failed'), (right) {
        expect(
          right,
          equals(tEpectedResponse),
        );
      });
    });

    test('should return DataBaseFailure if getting new words was unsuccessful',
        () async {
      when(mockVocabularyRemoteDataSource.getListWords(any))
          .thenThrow(DataBaseException('DB error', 400));
      final result = await vocabularyRepositoryImpl.getWordsList(tUserId);

      expect(
        result,
        equals(Left(DataBaseFailure(message: 'DB error', statusCode: 400))),
      );
    });
  });

  group('updateWord', () {
    final tWordEntity = WordEntity(
      id: 5,
      englishWord: 'cat',
      translation: 'кот',
      userId: '123',
      createdAt: DateTime.parse('2022-07-29T12:06:28+00:00'),
    );

    final tWordModel = WordModel.fromDomain(tWordEntity);
    test('should retrun WordEntity when adding word was successful', () async {
      when(mockVocabularyRemoteDataSource.updateWord(any))
          .thenAnswer((_) async => tWordModel);

      final result = await vocabularyRepositoryImpl.updateWord(tWordEntity);

      verify(mockVocabularyRemoteDataSource.updateWord(tWordModel));
      expect(result, equals(Right(tWordEntity)));
    });

    test('should return DataBaseFailure if updating  word was unsuccessful',
        () async {
      when(mockVocabularyRemoteDataSource.updateWord(any))
          .thenThrow(DataBaseException('DB error', 400));
      final result = await vocabularyRepositoryImpl.updateWord(tWordEntity);

      expect(
        result,
        equals(Left(DataBaseFailure(message: 'DB error', statusCode: 400))),
      );
    });
  });

  group('deleteWord', () {
    const tWordId = 10;

    test('should retrun Unit when deleting word was successful', () async {
      when(mockVocabularyRemoteDataSource.deleteWord(any))
          .thenAnswer((_) async => unit);

      final result = await vocabularyRepositoryImpl.deleteWord(tWordId);

      verify(mockVocabularyRemoteDataSource.deleteWord(tWordId));
      expect(result, equals(const Right(unit)));
    });

    test('should return DataBaseFailure if updating  word was unsuccessful',
        () async {
      when(mockVocabularyRemoteDataSource.deleteWord(any))
          .thenThrow(DataBaseException('DB error', 400));
      final result = await vocabularyRepositoryImpl.deleteWord(tWordId);

      expect(
        result,
        equals(Left(DataBaseFailure(message: 'DB error', statusCode: 400))),
      );
    });
  });
}
