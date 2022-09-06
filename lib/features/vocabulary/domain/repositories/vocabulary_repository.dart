import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/word_entity.dart';

abstract class VocabularyRepository {
  Future<Either<Failure, WordEntity>> addNewWord(Map<String, dynamic> word);
  Future<Either<Failure, WordEntity>> updateWord(
    WordEntity wordForUpdate,
  );
  Future<Either<Failure, Unit>> deleteWord(int id);
  Future<Either<Failure, List<WordEntity>>> getWordsList(String userId);
}
