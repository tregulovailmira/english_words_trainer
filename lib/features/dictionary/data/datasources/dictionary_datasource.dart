import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/word_description_model.dart';

final baseUrl = dotenv.env['DICTIONARY_BASE_URL'];

abstract class DictionaryDataSource {
  Future<WordDescriptionModel> getWordDescription(String word);
  Unit cancelRequest();
}

class DictionaryDataSourceImpl implements DictionaryDataSource {
  final Dio client;
  final List<Interceptor> interceptors;
  final _cancelToken = CancelToken();

  DictionaryDataSourceImpl({required this.client, required this.interceptors}) {
    client.interceptors.addAll(interceptors);
  }

  @override
  Future<WordDescriptionModel> getWordDescription(String word) async {
    final url = '$baseUrl/$word';
    try {
      final response = await client.get(url, cancelToken: _cancelToken);

      return WordDescriptionModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioError catch (e) {
      if (e.type == DioErrorType.cancel) {
        throw CanceledRequestException();
      }

      String errorMessage;
      final statusCode = e.response?.statusCode;

      if (statusCode == 401 || statusCode == 429) {
        errorMessage = e.response!.data['detail'];
      } else {
        errorMessage = (e.response!.data as List).first['message'];
      }

      throw ApiException(errorMessage, statusCode);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Unit cancelRequest() {
    _cancelToken.cancel();
    return unit;
  }
}
