import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/word_description.dart';
import '../repositories/dictionary_repository.dart';

class GetWordFromDictionary extends Usecase<WordDescription, GetWordParams> {
  final DictionaryRepository repository;

  GetWordFromDictionary(this.repository);

  @override
  Future<Either<Failure, WordDescription>> call(GetWordParams params) async {
    return await repository.getWordFromDictionary(params.word);
  }
}

class GetWordParams extends Equatable {
  final String word;

  const GetWordParams({required this.word});

  @override
  List<Object?> get props => [word];
}
