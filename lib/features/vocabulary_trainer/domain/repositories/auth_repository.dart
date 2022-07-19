import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';

abstract class AuthRepositry {
  Future<Either<Failure, Unit>> signInWithEmailAndPassword(
      {required String email, required String password});
  Future<Either<Failure, Unit>> signUp(
      {required String email, required String password});
  Future<Either<Failure, User>> getSignedInUser();
}
