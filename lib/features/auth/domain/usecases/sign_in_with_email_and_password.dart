import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailAndPassword extends Usecase<Unit, AuthParams> {
  final AuthRepository repository;

  SignInWithEmailAndPassword(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AuthParams params) async {
    return await repository.signInWithEmailAndPassword(
        email: params.email, password: params.password);
  }
}
