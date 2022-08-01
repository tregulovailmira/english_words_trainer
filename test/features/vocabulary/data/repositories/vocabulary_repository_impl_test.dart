import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/errors/exceptions.dart';
import 'package:english_words_trainer/core/errors/failures.dart';
import 'package:english_words_trainer/features/vocabulary/data/datasources/vocabulary_remote_datasource.dart';
import 'package:english_words_trainer/features/vocabulary/data/models/word_model.dart';
import 'package:english_words_trainer/features/vocabulary/data/repositories/vocabulary_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'vocabulary_repository_impl_test.mocks.dart';

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
    const tNewWord = {
      'englishWord': 'cat',
      'translation': 'кот',
      'userId': '12345',
    };
    test('should retrun unit when adding new word was successful', () async {
      when(mockVocabularyRemoteDataSource.addNewWord(any))
          .thenAnswer((_) async => unit);

      final result = await vocabularyRepositoryImpl.addNewWord(tNewWord);

      verify(mockVocabularyRemoteDataSource.addNewWord(tNewWord));
      expect(result, equals(const Right(unit)));
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
    test('should retrun WordEntity when getting words was successful',
        () async {
      when(mockVocabularyRemoteDataSource.getListWords(any))
          .thenAnswer((_) async => tWordsModelList);

      final result = await vocabularyRepositoryImpl.getWordsList(tUserId);

      verify(mockVocabularyRemoteDataSource.getListWords(tUserId));
      expect(result, equals(Right(tWordsModelList)));
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
}
