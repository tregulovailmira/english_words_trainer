import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/errors/failures.dart';
import 'package:english_words_trainer/core/usecases/usecase.dart';
import 'package:english_words_trainer/features/vocabulary_trainer/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class SignUp extends Usecase<Unit, Params> {
  final AuthRepositry repository;

  SignUp(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Params params) async {
    return await repository.signUp(
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
