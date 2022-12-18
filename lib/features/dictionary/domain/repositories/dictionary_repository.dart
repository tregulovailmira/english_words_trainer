import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/word_description.dart';

abstract class DictionaryRepository {
  Future<Either<Failure, WordDescription>> getWordFromDictionary(String word);
  Either<Failure, Unit> cancelRequest();
}
