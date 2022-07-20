import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:english_words_trainer/core/errors/exceptions.dart';
import 'package:english_words_trainer/core/errors/failures.dart';
import 'package:english_words_trainer/features/auth/data/datasources/db_datasource.dart';
import 'package:english_words_trainer/features/auth/data/models/user_model.dart';
import 'package:english_words_trainer/features/auth/data/repositories/auth_repository_impl.dart';

import './auth_repository_impl_test.mocks.dart';

@GenerateMocks([DbDataSource])
void main() {
  late MockDbDataSource mockDbDataSource;
  late AuthRepositoryImpl authRepositoryImpl;
  setUp(() {
    mockDbDataSource = MockDbDataSource();
    authRepositoryImpl = AuthRepositoryImpl(mockDbDataSource);
  });

  const email = 'test@test.com';
  const password = 'testPassword';

  group('signInWithEmailAndPassword', () {
    test('should return unit when signin in is successful', () async {
      when(mockDbDataSource.sighInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => unit);
      final result = await authRepositoryImpl.signInWithEmailAndPassword(
          email: email, password: password);
      verify(mockDbDataSource.sighInWithEmailAndPassword(
          email: email, password: password));
      expect(result, equals(const Right(unit)));
    });

    test('should return DatabaseFailure when signin in is unsuccessful',
        () async {
      when(mockDbDataSource.sighInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(DataBaseException('DB error'));
      final result = await authRepositoryImpl.signInWithEmailAndPassword(
          email: email, password: password);
      verify(mockDbDataSource.sighInWithEmailAndPassword(
          email: email, password: password));
      expect(result, equals(Left(DataBaseFailure(message: 'DB error'))));
    });
  });

  group('signUp', () {
    test('should return unit when signin up is successful', () async {
      when(mockDbDataSource.sighUp(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => unit);
      final result =
          await authRepositoryImpl.signUp(email: email, password: password);
      verify(mockDbDataSource.sighUp(email: email, password: password));
      expect(result, equals(const Right(unit)));
    });

    test('should return DatabaseFailure when signin up is unsuccessful',
        () async {
      when(mockDbDataSource.sighUp(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(DataBaseException('DB error'));
      final result =
          await authRepositoryImpl.signUp(email: email, password: password);
      verify(mockDbDataSource.sighUp(email: email, password: password));
      expect(result, equals(Left(DataBaseFailure(message: 'DB error'))));
    });
  });

  group('getSignedInUser', () {
    const tUserModel =
        UserModel(id: "123", email: 'test@test.com', phone: '123456');
    test('should return UserEntity when signed in user exists', () async {
      when(mockDbDataSource.getSignedInUser())
          .thenAnswer((_) async => tUserModel);
      final result = await authRepositoryImpl.getSignedInUser();
      verify(mockDbDataSource.getSignedInUser());
      expect(result, equals(const Right(tUserModel)));
    });

    test('should return null when signed in user doesn\'t exist', () async {
      when(mockDbDataSource.getSignedInUser()).thenAnswer((_) async => null);
      final result = await authRepositoryImpl.getSignedInUser();
      verify(mockDbDataSource.getSignedInUser());
      expect(result, const Right(null));
    });

    test(
        'should return DatabaseFailure when getting signed in user is unsuccessful',
        () async {
      when(mockDbDataSource.getSignedInUser())
          .thenThrow(DataBaseException('DB error'));
      final result = await authRepositoryImpl.getSignedInUser();
      verify(mockDbDataSource.getSignedInUser());
      expect(result, equals(Left(DataBaseFailure(message: 'DB error'))));
    });
  });
}
