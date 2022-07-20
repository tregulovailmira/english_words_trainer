import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepositry {
  Future<Either<Failure, Unit>> signInWithEmailAndPassword(
      {required String email, required String password});
  Future<Either<Failure, Unit>> signUp(
      {required String email, required String password});
  Future<Either<Failure, UserEntity?>> getSignedInUser();
}
