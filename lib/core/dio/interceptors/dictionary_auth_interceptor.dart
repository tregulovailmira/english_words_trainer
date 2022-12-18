import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DictionaryAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final apiToken = dotenv.env['DICTIONARY_API_TOKEN'];
    options.headers['Authorization'] = 'Token $apiToken';
    super.onRequest(options, handler);
  }
}
