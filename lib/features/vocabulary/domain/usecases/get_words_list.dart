import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/word_entity.dart';
import '../repositories/vocabulary_repository.dart';

class GetWordsList extends Usecase<List<WordEntity>, Params> {
  GetWordsList(this.repository);

  final VocabularyRepository repository;

  @override
  Future<Either<Failure, List<WordEntity>>> call(Params params) async {
    return await repository.getWordsList(params.userId);
  }
}

class Params extends Equatable {
  const Params({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}
