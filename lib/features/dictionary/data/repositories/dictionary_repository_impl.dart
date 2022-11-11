import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_handlers.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/word_description.dart';
import '../../domain/repositories/dictionary_repository.dart';
import '../datasources/dictionary_datasource.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  final DictionaryDataSource dataSource;

  DictionaryRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, WordDescription>> getWordFromDictionary(
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
