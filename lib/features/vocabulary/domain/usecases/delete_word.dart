import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/vocabulary_repository.dart';

class DeleteWord extends Usecase<Unit, DeleteWordParams> {
  final VocabularyRepository repository;

  DeleteWord(this.repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteWordParams params) async {
    return await repository.deleteWord(params.id);
  }
}

class DeleteWordParams extends Equatable {
  final int id;

  const DeleteWordParams({required this.id});

  @override
  List<Object?> get props => [id];
}
