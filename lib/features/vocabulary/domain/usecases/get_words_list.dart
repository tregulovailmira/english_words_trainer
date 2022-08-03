import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/word_entity.dart';
import '../repositories/vocabulary_repository.dart';

class GetWordsList extends Usecase<List<WordEntity>, GetWordsParams> {
  final VocabularyRepository repository;

  GetWordsList(this.repository);

  @override
  Future<Either<Failure, List<WordEntity>>> call(GetWordsParams params) async {
    return await repository.getWordsList(params.userId);
  }
}

class GetWordsParams extends Equatable {
  const GetWordsParams({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}
