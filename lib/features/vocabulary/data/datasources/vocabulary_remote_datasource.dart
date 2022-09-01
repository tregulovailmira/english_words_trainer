import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/word_model.dart';

final tableName = dotenv.env['VOCABULARY_TABLE_NAME']!;

abstract class VocabularyRemoteDataSource {
  Future<WordModel> addNewWord(Map<String, dynamic> word);

  Future<List<WordModel>> getListWords(String userId);
}

class VocabularyRemoteDataSourceImpl implements VocabularyRemoteDataSource {
  final SupabaseClient client;

  VocabularyRemoteDataSourceImpl({required this.client});

  @override
  Future<WordModel> addNewWord(Map<String, dynamic> word) async {
    final response = await client.from(tableName).insert(word).execute();
    if (response.status != 201) {
      throw DataBaseException(response.error!.message, response.status);
    }
    return WordModel.fromJson(response.data[0]);
  }

  @override
  Future<List<WordModel>> getListWords(String userId) async {
    final response = await client
        .from(tableName)
        .select()
        .filter('userId', 'eq', userId)
        .execute();
    if (response.status != 200) {
      throw DataBaseException(response.error!.message, response.status);
    }
    return (response.data as List)
        .map((word) => WordModel.fromJson(word))
        .toList();
  }
}
