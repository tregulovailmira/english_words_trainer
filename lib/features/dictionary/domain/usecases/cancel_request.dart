import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase_sync.dart';
import '../repositories/dictionary_repository.dart';

class CancelRequest extends UsecaseSync<Unit, NoParams> {
  final DictionaryRepository repository;

  CancelRequest(this.repository);

  @override
  Either<Failure, Unit> call(NoParams params) {
    return repository.cancelRequest();
  }
}
