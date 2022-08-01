import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/errors/exceptions.dart';
import 'package:english_words_trainer/features/vocabulary/data/models/word_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const tableName = 'vocabulary';

abstract class VocabularyRemoteDataSource {
  Future<Unit> addNewWord(Map<String, dynamic> word);

  Future<List<WordModel>> getListWords(String userId);
}

class VocabularyRemoteDataSourceImpl implements VocabularyRemoteDataSource {
  final SupabaseClient client;

  VocabularyRemoteDataSourceImpl({required this.client});

  @override
  Future<Unit> addNewWord(Map<String, dynamic> word) async {
    final response = await client.from(tableName).insert(word).execute();
    if (response.status != 201) {
      throw DataBaseException(response.error!.message, response.status);
    }
    return unit;
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
    final words =
        (response.data as List).map((word) => WordModel.fromMap(word)).toList();
    return words;
  }
}
