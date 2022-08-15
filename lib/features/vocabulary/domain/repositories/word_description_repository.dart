import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/word_api_description_entity.dart';

abstract class WordDescriptionRepository {
  Future<Either<Failure, WordApiDescriptionEntity>> getDescription(
    String word,
  );
}
