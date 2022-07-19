import 'package:english_words_trainer/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/usecases/usecase.dart';
import 'package:english_words_trainer/features/vocabulary_trainer/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../entities/user_entity.dart';


class GetSignedInUser extends Usecase<UserEntity, NoParams> {
  final AuthRepositry repository;

  GetSignedInUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async{
    return await repository.getSignedInUser();
  }
}
