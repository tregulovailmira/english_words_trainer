import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/errors/exceptions.dart';
import 'package:english_words_trainer/core/errors/failures.dart';
import 'package:english_words_trainer/features/vocabulary/data/datasources/word_api_datasource.dart';
import 'package:english_words_trainer/features/vocabulary/data/models/word_description_model.dart';
import 'package:english_words_trainer/features/vocabulary/data/repositories/word_description_repositoty_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'mocks/word_description_repository_impl_test.mocks.dart';

@GenerateMocks([WordApiDataSource])
void main() {
  late MockWordApiDataSource mockWordApiDataSource;
  late WordDescriptionRepositoryImpl repository;
  const tWord = 'attract';

  setUp(() {
    mockWordApiDataSource = MockWordApiDataSource();
    repository = WordDescriptionRepositoryImpl(mockWordApiDataSource);
  });

  test(
    'should return WordApiDescriptionEntity whet request was successful',
    () async {
      final tDataSourceResponse = WordDescriptionModel.fromJson(
        json.decode(
          fixture('api_success_response.json'),
        )[0],
      );

      final tExpectedResult = tDataSourceResponse.toDomain();

      when(mockWordApiDataSource.getWordDescription(any)).thenAnswer(
        (_) async => tDataSourceResponse,
      );

      final result = await repository.getDescription(tWord);

      expect(result, equals(Right(tExpectedResult)));
    },
  );

  test(
    'should return v whet request was unsuccessful',
    () async {
      when(mockWordApiDataSource.getWordDescription(any)).thenThrow(
        ApiException('Not found', 404),
      );

      final result = await repository.getDescription(tWord);

      expect(
        result,
        equals(Left(ApiFailure(message: 'Not found', statusCode: 404))),
      );
    },
  );
}
