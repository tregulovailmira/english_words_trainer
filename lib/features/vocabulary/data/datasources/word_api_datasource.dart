import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../../core/errors/exceptions.dart';
import '../models/word_description_model.dart';

final baseUrl = dotenv.env['API_BASE_URL'];

abstract class WordApiDataSource {
  Future<WordDescriptionModel> getWordDescription(String word);
}

class WordApiDataSourceImpl implements WordApiDataSource {
  final http.Client client;

  WordApiDataSourceImpl(this.client);

  @override
  Future<WordDescriptionModel> getWordDescription(String word) async {
    final url = '$baseUrl/$word';
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return WordDescriptionModel.fromJson(
          (json.decode(response.body) as List).first,
        );
      } else {
        final message = json.decode(response.body)['message'] as String;
        throw ApiException(message, response.statusCode);
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
