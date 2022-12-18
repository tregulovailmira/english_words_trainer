import 'package:dartz/dartz.dart';

import '../../../../core/errors/errors_handlers.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/db_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DbDataSource dbDataSource;

  AuthRepositoryImpl(this.dbDataSource);

  @override
  Future<Either<Failure, UserEntity?>> getSignedInUser() async {
    try {
      final result = await dbDataSource.getSignedInUser();
      return Right(result);
    } catch (e) {
      return Left(exceptionHandler(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await dbDataSource.sighInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return const Right(unit);
    } catch (e) {
      return Left(exceptionHandler(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await dbDataSource.sighUp(email: email, password: password);
      return const Right(unit);
    } catch (e) {
      return Left(exceptionHandler(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await dbDataSource.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(exceptionHandler(e));
    }
  }

}
