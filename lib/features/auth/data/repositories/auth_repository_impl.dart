import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/db_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.dbDataSource);
  final DbDataSource dbDataSource;

  @override
  Future<Either<Failure, UserEntity?>> getSignedInUser() async {
    try {
      final result = await dbDataSource.getSignedInUser();
      return Right(result);
    } on DataBaseException catch (e) {
      return Left(
          DataBaseFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Unit>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await dbDataSource.sighInWithEmailAndPassword(
          email: email, password: password);
      return const Right(unit);
    } on DataBaseException catch (e) {
      return Left(
          DataBaseFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, Unit>> signUp(
      {required String email, required String password}) async {
    try {
      await dbDataSource.sighUp(email: email, password: password);
      return const Right(unit);
    } on DataBaseException catch (e) {
      return Left(
          DataBaseFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
