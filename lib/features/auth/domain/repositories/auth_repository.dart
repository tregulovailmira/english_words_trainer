import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, Unit>> signUp({
    required String email,
    required String password,
  });
  Future<Either<Failure, UserEntity?>> getSignedInUser();
  Future<Either<Failure, Unit>> signOut();
}
