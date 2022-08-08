import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/errors/failures.dart';
import 'package:english_words_trainer/core/usecases/usecase.dart';
import 'package:english_words_trainer/features/auth/domain/entities/user_entity.dart';
import 'package:english_words_trainer/features/auth/domain/usecases/get_signed_in_user.dart';
import 'package:english_words_trainer/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:english_words_trainer/features/auth/domain/usecases/sign_up.dart';
import 'package:english_words_trainer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/auth_bloc_test.mocks.dart';

@GenerateMocks([SignInWithEmailAndPassword, SignUp, GetSignedInUser])
void main() {
  late AuthBloc authBloc;
  late MockSignInWithEmailAndPassword mockSignInWithEmailAndPassword;
  late MockSignUp mockSignUp;
  late MockGetSignedInUser mockGetSignedInUser;

  const email = 'test@test.com';
  const password = 'testPassword';

  setUp(() {
    mockSignInWithEmailAndPassword = MockSignInWithEmailAndPassword();
    mockSignUp = MockSignUp();
    mockGetSignedInUser = MockGetSignedInUser();

    authBloc = AuthBloc(
      signIn: mockSignInWithEmailAndPassword,
      signUp: mockSignUp,
      getUser: mockGetSignedInUser,
    );
  });

  test('initialState should be empty SignInInitial', () {
    // assert
    expect(authBloc.state, equals(AuthInitial()));
  });

  group('signIn', () {
    test('should sign in user via sign in use case', () async {
      when(mockSignInWithEmailAndPassword(any))
          .thenAnswer((_) async => const Right(unit));
      authBloc.add(
        SignInWithEmailAndPasswordEvent(
          email: email,
          password: password,
        ),
      );
      await untilCalled(mockSignInWithEmailAndPassword(any));
      verify(
        mockSignInWithEmailAndPassword(
          const AuthParams(
            email: email,
            password: password,
          ),
        ),
      );
    });

    test(
        'should emit [AuthLoading, AuthLoaded] when signing in was successfully',
        () async {
      when(mockSignInWithEmailAndPassword(any))
          .thenAnswer((_) async => const Right(unit));

      final expectedStates = [
        AuthLoading(),
        const AuthLoaded(),
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedStates));

      authBloc.add(
        SignInWithEmailAndPasswordEvent(
          email: email,
          password: password,
        ),
      );
    });

    test(
        'should emit [AuthLoading, AuthError] when signing in was unsuccessfully',
        () async {
      when(mockSignInWithEmailAndPassword(any))
          .thenAnswer((_) async => Left(DataBaseFailure(message: 'DB error')));

      final expectedStates = [
        AuthLoading(),
        const AuthError(message: 'DB error')
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedStates));

      authBloc.add(
        SignInWithEmailAndPasswordEvent(
          email: email,
          password: password,
        ),
      );
    });
  });

  group('signUp', () {
    test('should sign up user via sign up use case', () async {
      when(mockSignUp(any)).thenAnswer((_) async => const Right(unit));
      authBloc.add(SignUpNewUser(email: email, password: password));
      await untilCalled(mockSignUp(any));
      verify(mockSignUp(const AuthParams(email: email, password: password)));
    });

    test(
        'should emit [AuthLoading, AuthLoaded] when signing up was successfully',
        () async {
      when(mockSignUp(any)).thenAnswer((_) async => const Right(unit));

      final expectedStates = [
        AuthLoading(),
        const AuthLoaded(),
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedStates));

      authBloc.add(SignUpNewUser(email: email, password: password));
    });

    test(
        'should emit [AuthLoading, AuthError] when signing in was unsuccessfully',
        () async {
      when(mockSignUp(any))
          .thenAnswer((_) async => Left(DataBaseFailure(message: 'DB error')));

      final expectedStates = [
        AuthLoading(),
        const AuthError(message: 'DB error')
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedStates));

      authBloc.add(SignUpNewUser(email: email, password: password));
    });
  });

  group('GetSignedInUser', () {
    const tUserEntity = UserEntity(
      id: '123',
      email: 'email@test.com',
      phone: '123',
    );

    test('should get user via sign up use case', () async {
      when(mockGetSignedInUser(any))
          .thenAnswer((_) async => const Right(tUserEntity));
      authBloc.add(SignedInUser());
      await untilCalled(mockGetSignedInUser(any));
      verify(mockGetSignedInUser(NoParams()));
    });

    test(
        'should emit [AuthLoading, AuthLoaded] when getting user was successfully',
        () async {
      when(mockGetSignedInUser(any))
          .thenAnswer((_) async => const Right(tUserEntity));

      final expectedStates = [
        AuthLoading(),
        const AuthLoaded(user: tUserEntity),
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedStates));
      authBloc.add(SignedInUser());
    });

    test('should emit AuthLoaded without user when user doesn\'t exists',
        () async {
      when(mockGetSignedInUser(any)).thenAnswer((_) async => const Right(null));

      final expectedState = [
        AuthLoading(),
        const AuthLoaded(user: null),
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedState));
      authBloc.add(SignedInUser());
    });

    test(
        'should emit [AuthLoaded, AuthError] when gettinf user was unsuccessful',
        () async {
      when(mockGetSignedInUser(any))
          .thenAnswer((_) async => Left(DataBaseFailure(message: 'DB error')));

      final expectedStates = [
        AuthLoading(),
        const AuthError(message: 'DB error')
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedStates));

      authBloc.add(SignedInUser());
    });
  });
}
