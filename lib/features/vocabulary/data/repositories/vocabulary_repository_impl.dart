import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/word_entity.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../datasources/vocabulary_remote_datasource.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  VocabularyRepositoryImpl(this.dataSource);

  final VocabularyRemoteDataSource dataSource;

  @override
  Future<Either<Failure, List<WordEntity>>> getWordsList(String userId) async {
    try {
      final result = await dataSource.getListWords(userId);
      return Right(result);
    } on DataBaseException catch (e) {
      return Left(
          DataBaseFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, WordEntity>> addNewWord(Map<String, dynamic> word) async {
    try {
      final result = await dataSource.addNewWord(word);
      return Right(result);
    } on DataBaseException catch (e) {
      return Left(
          DataBaseFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
