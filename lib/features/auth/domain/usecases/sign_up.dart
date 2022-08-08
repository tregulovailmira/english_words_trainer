import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignUp extends Usecase<Unit, AuthParams> {
  final AuthRepository repository;

  SignUp(this.repository);

  @override
  Future<Either<Failure, Unit>> call(AuthParams params) async {
    return await repository.signUp(
      email: params.email,
      password: params.password,
    );
  }
}
