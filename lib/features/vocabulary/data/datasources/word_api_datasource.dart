import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/word_description_model.dart';

final baseUrl = dotenv.env['VOCABULARY_BASE_URL'];

abstract class WordApiDataSource {
  Future<WordDescriptionModel> getWordDescription(String word);
}

class WordApiDataSourceImpl implements WordApiDataSource {
  final Dio client;

  WordApiDataSourceImpl(this.client);

  @override
  Future<WordDescriptionModel> getWordDescription(String word) async {
    final url = '$baseUrl/$word';
    try {
      final response = await client.get(url);
      return WordDescriptionModel.fromJson((response.data as List).first);
    } on DioError catch (e) {
      final errorMesage =
          e.response != null ? e.response!.data['message'] : e.message;
      final statusCode = e.response?.statusCode;

      throw ApiException(errorMesage, statusCode);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
