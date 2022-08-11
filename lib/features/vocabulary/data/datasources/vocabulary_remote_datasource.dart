import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/word_model.dart';

final tableName = dotenv.env['VOCABULARY_TABLE_NAME']!;

abstract class VocabularyRemoteDataSource {
  Future<WordModel> addNewWord(Map<String, dynamic> word);
  Future<WordModel> updateWord(WordModel word);
  Future<Unit> deleteWord(int id);
  Future<List<WordModel>> getListWords(String id);
}

class VocabularyRemoteDataSourceImpl implements VocabularyRemoteDataSource {
  final SupabaseClient client;

  VocabularyRemoteDataSourceImpl({required this.client});

  @override
  Future<WordModel> addNewWord(Map<String, dynamic> word) async {
    final response = await client.from(tableName).insert(word).execute();

    _handleError(response, 201);

    return WordModel.fromJson(response.data[0]);
  }

  @override
  Future<List<WordModel>> getListWords(String userId) async {
    final response = await client
        .from(tableName)
        .select()
        .filter('userId', 'eq', userId)
        .execute();

    _handleError(response, 200);

    return (response.data as List)
        .map((word) => WordModel.fromJson(word))
        .toList();
  }

  @override
  Future<WordModel> updateWord(WordModel word) async {
    final response = await client.from(tableName).update({
      'translation': word.translation,
      'englishWord': word.englishWord,
    }).match({'id': word.id}).execute();

    _handleError(response, 200);

    return WordModel.fromJson(response.data[0]);
  }

  @override
  Future<Unit> deleteWord(int id) async {
    final response = await client.from(tableName).delete().match({
      'id': id,
    }).execute();

    _handleError(response, 200);

    return unit;
  }

  _handleError(response, expectedStatus) {
    if (response.status != expectedStatus) {
      throw DataBaseException(
        response.error!.message,
        response.status,
      );
    }
  }
}
