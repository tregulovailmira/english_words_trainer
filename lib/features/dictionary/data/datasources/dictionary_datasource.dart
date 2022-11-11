import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/word_description_model.dart';

final baseUrl = dotenv.env['DICTIONARY_BASE_URL'];

abstract class DictionaryDataSource {
  Future<WordDescriptionModel> getWordDescription(String word);
}

class DictionaryDataSourceImpl implements DictionaryDataSource {
  final Dio client;
  final List<Interceptor> interceptors;

  DictionaryDataSourceImpl({required this.client, required this.interceptors}) {
    client.interceptors.addAll(interceptors);
  }

  @override
  Future<WordDescriptionModel> getWordDescription(String word) async {
    final url = '$baseUrl/$word';
    try {
      final response = await client.get(url);

      return WordDescriptionModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioError catch (e) {
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
}
