import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/features/vocabulary/domain/entities/word_entity.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/vocabulary_repository.dart';

class AddNewWord extends Usecase<WordEntity, AddNewWordParams> {
  AddNewWord(this.repository);

  final VocabularyRepository repository;

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
