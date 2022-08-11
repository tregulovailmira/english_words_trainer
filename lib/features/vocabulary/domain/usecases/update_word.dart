import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/word_entity.dart';
import '../repositories/vocabulary_repository.dart';

class UpdateWord extends Usecase<WordEntity, UpdateWordParams> {
  final VocabularyRepository repository;

  UpdateWord(this.repository);

  @override
  Future<Either<Failure, WordEntity>> call(UpdateWordParams params) async {
    return await repository.updateWord(params.word);
  }
}

class UpdateWordParams extends Equatable {
  const UpdateWordParams({required this.word});

  final WordEntity word;

  @override
  List<Object?> get props => [word];
}
