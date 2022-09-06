import 'dart:convert';

import 'package:english_words_trainer/core/errors/exceptions.dart';
import 'package:english_words_trainer/features/vocabulary/data/datasources/word_api_datasource.dart';
import 'package:english_words_trainer/features/vocabulary/data/models/word_description_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'mocks/word_api_datasource_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  dotenv.testLoad(fileInput: "API_BASE_URL='https://test.com'");

  const tWord = 'attract';
  final tWordUrl = '${dotenv.env['API_BASE_URL']}/$tWord';
  late MockClient mockHttpClient;
  late WordApiDataSourceImpl wordApiDataSource;

  setUp(() {
    mockHttpClient = MockClient();
    wordApiDataSource = WordApiDataSourceImpl(mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any)).thenAnswer(
      (_) async => http.Response(fixture('api_success_response.json'), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any)).thenAnswer(
      (_) async => http.Response(fixture('api_fail_response.json'), 404),
    );
  }

  test('should call get method of http client', () async {
    //arrange
    setUpMockHttpClientSuccess200();
    // act
    wordApiDataSource.getWordDescription(tWord);
    // assert
    verify(
      mockHttpClient.get(
        Uri.parse(tWordUrl),
      ),
    );
  });

  test(
    'should return NumberTrivia when the response code is 200 (success)',
    () async {
      // arrange
      final tExpectedResult = WordDescriptionModel.fromJson(
        json.decode(fixture('api_success_response.json'))[0],
      );
      setUpMockHttpClientSuccess200();
      // act
      final result = await wordApiDataSource.getWordDescription(tWord);
      // assert
      expect(result, equals(tExpectedResult));
    },
  );

  test(
    'should throw a ServerException when the response code is 404 or other',
    () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = wordApiDataSource.getWordDescription;
      // assert
      expect(
        () => call(tWord),
        throwsA(const TypeMatcher<ApiException>()),
      );
    },
  );
}
