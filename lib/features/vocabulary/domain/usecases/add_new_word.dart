import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/word_entity.dart';
import '../repositories/vocabulary_repository.dart';

class AddNewWord extends Usecase<WordEntity, AddNewWordParams> {
  final VocabularyRepository repository;

  AddNewWord(this.repository);

  @override
  Future<Either<Failure, WordEntity>> call(AddNewWordParams params) async {
    return await repository.addNewWord(params.word);
  }
}

class AddNewWordParams extends Equatable {
  const AddNewWordParams({required this.word});

  final Map<String, dynamic> word;

  @override
  List<Object?> get props => [word];
}
