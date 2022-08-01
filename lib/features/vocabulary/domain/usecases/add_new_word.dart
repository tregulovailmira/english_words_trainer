import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/vocabulary_repository.dart';

class AddNewWord extends Usecase<Unit, Params> {
  AddNewWord(this.repository);

  final VocabularyRepository repository;

  @override
  Future<Either<Failure, Unit>> call(Params params) async {
    return await repository.addNewWord(params.word);
  }
}

class Params extends Equatable {
  const Params({required this.word});

  final Map<String, dynamic> word;

  @override
  List<Object?> get props => [word];
}
