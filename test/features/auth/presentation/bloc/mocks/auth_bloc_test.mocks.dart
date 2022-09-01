// Mocks generated by Mockito 5.2.0 from annotations
// in english_words_trainer/test/features/auth/presentation/bloc/auth_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:english_words_trainer/core/errors/failures.dart' as _i6;
import 'package:english_words_trainer/core/usecases/usecase.dart' as _i7;
import 'package:english_words_trainer/features/auth/domain/entities/user_entity.dart'
    as _i10;
import 'package:english_words_trainer/features/auth/domain/repositories/auth_repository.dart'
    as _i2;
import 'package:english_words_trainer/features/auth/domain/usecases/get_signed_in_user.dart'
    as _i9;
import 'package:english_words_trainer/features/auth/domain/usecases/sign_in_with_email_and_password.dart'
    as _i4;
import 'package:english_words_trainer/features/auth/domain/usecases/sign_up.dart'
    as _i8;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeAuthRepository_0 extends _i1.Fake implements _i2.AuthRepository {}

class _FakeEither_1<L, R> extends _i1.Fake implements _i3.Either<L, R> {}

/// A class which mocks [SignInWithEmailAndPassword].
///
/// See the documentation for Mockito's code generation for more information.
class MockSignInWithEmailAndPassword extends _i1.Mock
    implements _i4.SignInWithEmailAndPassword {
  MockSignInWithEmailAndPassword() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeAuthRepository_0()) as _i2.AuthRepository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, _i3.Unit>> call(_i7.AuthParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue: Future<_i3.Either<_i6.Failure, _i3.Unit>>.value(
                  _FakeEither_1<_i6.Failure, _i3.Unit>()))
          as _i5.Future<_i3.Either<_i6.Failure, _i3.Unit>>);
}

/// A class which mocks [SignUp].
///
/// See the documentation for Mockito's code generation for more information.
class MockSignUp extends _i1.Mock implements _i8.SignUp {
  MockSignUp() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeAuthRepository_0()) as _i2.AuthRepository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, _i3.Unit>> call(_i7.AuthParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
              returnValue: Future<_i3.Either<_i6.Failure, _i3.Unit>>.value(
                  _FakeEither_1<_i6.Failure, _i3.Unit>()))
          as _i5.Future<_i3.Either<_i6.Failure, _i3.Unit>>);
}

/// A class which mocks [GetSignedInUser].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetSignedInUser extends _i1.Mock implements _i9.GetSignedInUser {
  MockGetSignedInUser() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AuthRepository get repository =>
      (super.noSuchMethod(Invocation.getter(#repository),
          returnValue: _FakeAuthRepository_0()) as _i2.AuthRepository);
  @override
  _i5.Future<_i3.Either<_i6.Failure, _i10.UserEntity?>> call(
          _i7.NoParams? params) =>
      (super.noSuchMethod(Invocation.method(#call, [params]),
          returnValue: Future<_i3.Either<_i6.Failure, _i10.UserEntity?>>.value(
              _FakeEither_1<_i6.Failure, _i10.UserEntity?>())) as _i5
          .Future<_i3.Either<_i6.Failure, _i10.UserEntity?>>);
}
