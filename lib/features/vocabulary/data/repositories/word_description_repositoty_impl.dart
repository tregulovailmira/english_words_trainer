import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_handlers.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/word_api_description_entity.dart';
import '../../domain/repositories/word_description_repository.dart';
import '../datasources/word_api_datasource.dart';

class WordDescriptionRepositoryImpl implements WordDescriptionRepository {
  final WordApiDataSource dataSource;

  WordDescriptionRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, WordApiDescriptionEntity>> getDescription(
    String word,
  ) async {
    try {
      final response = await dataSource.getWordDescription(word);
      return Right(response.toDomain());
    } catch (e) {
      return Left(exceptionHandler(e));
    }
  }
}
