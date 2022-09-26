import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/word_api_description_entity.dart';
import '../repositories/word_description_repository.dart';

class GetWordDescription
    extends Usecase<WordApiDescriptionEntity, GetWordDescriptionParams> {
  final WordDescriptionRepository repository;

  GetWordDescription(this.repository);

  @override
  Future<Either<Failure, WordApiDescriptionEntity>> call(
    GetWordDescriptionParams params,
  ) async {
    return await repository.getDescription(params.word);
  }
}

class GetWordDescriptionParams extends Equatable {
  const GetWordDescriptionParams({required this.word});

  final String word;

  @override
  List<Object?> get props => [word];
}
