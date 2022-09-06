import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/word_entity.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../datasources/vocabulary_remote_datasource.dart';
import '../models/word_model.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  final VocabularyRemoteDataSource dataSource;

  VocabularyRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<WordEntity>>> getWordsList(String userId) async {
    try {
      final result = await dataSource.getListWords(userId);
      return Right(result.map((word) => word.toDomain()).toList());
    } on DataBaseException catch (e) {
      return Left(
        DataBaseFailure(message: e.message, statusCode: e.statusCode),
      );
    }
  }

  @override
  Future<Either<Failure, WordEntity>> addNewWord(
    Map<String, dynamic> word,
  ) async {
    try {
      final result = await dataSource.addNewWord(word);
      return Right(result.toDomain());
    } on DataBaseException catch (e) {
      return Left(
        DataBaseFailure(message: e.message, statusCode: e.statusCode),
      );
    }
  }

  @override
  Future<Either<Failure, WordEntity>> updateWord(
    WordEntity wordForUpdate,
  ) async {
    try {
      final result = await dataSource.updateWord(
        WordModel.fromDomain(wordForUpdate),
      );
      return Right(result.toDomain());
    } on DataBaseException catch (e) {
      return Left(
        DataBaseFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteWord(int id) async {
    try {
      await dataSource.deleteWord(id);
      return const Right(unit);
    } on DataBaseException catch (e) {
      return Left(
        DataBaseFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    }
  }
}
