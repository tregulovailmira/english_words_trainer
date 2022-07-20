import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailAndPassword extends Usecase<Unit, Params> {
  final AuthRepositry repository;

  SignInWithEmailAndPassword(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Params params) async {
    return await repository.signInWithEmailAndPassword(
        email: params.email, password: params.password);
  }
}

class Params extends Equatable {
  const Params({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
