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

import './auth_bloc_test.mocks.dart';

@GenerateMocks([SignInWithEmailAndPassword, SignUp, GetSignedInUser])
void main() {
  const email = 'test@test.com';
  const password = 'testPassword';
  group('signIn', () {
    late SignInBloc signInBloc;
    late MockSignInWithEmailAndPassword mockSignInWithEmailAndPassword;

    setUp(() {
      mockSignInWithEmailAndPassword = MockSignInWithEmailAndPassword();
      signInBloc = SignInBloc(signIn: mockSignInWithEmailAndPassword);
    });
    test('initialState should be empty SignInInitial', () {
      // assert
      expect(signInBloc.state, equals(SignInInitial()));
    });

    test('should sign in user via sign in use case', () async {
      when(mockSignInWithEmailAndPassword(any))
          .thenAnswer((_) async => const Right(unit));
      signInBloc.add(
          SignInWithEmailAndPasswordEvent(email: email, password: password));
      await untilCalled(mockSignInWithEmailAndPassword(any));
      verify(mockSignInWithEmailAndPassword(
          const AuthParams(email: email, password: password)));
    });

    test(
        'should emit [SignInLoading, SignInLoaded] when signing in was successfully',
        () async {
      when(mockSignInWithEmailAndPassword(any))
          .thenAnswer((_) async => const Right(unit));

      final expectedStates = [
        SignInLoading(),
        SignInLoaded(),
      ];

      expectLater(signInBloc.stream, emitsInOrder(expectedStates));

      signInBloc.add(
          SignInWithEmailAndPasswordEvent(email: email, password: password));
    });

    test(
        'should emit [SignInLoading, SignInError] when signing in was unsuccessfully',
        () async {
      when(mockSignInWithEmailAndPassword(any))
          .thenAnswer((_) async => Left(DataBaseFailure(message: 'DB error')));

      final expectedStates = [
        SignInLoading(),
        const SignInError(message: 'DB error')
      ];

      expectLater(signInBloc.stream, emitsInOrder(expectedStates));

      signInBloc.add(
          SignInWithEmailAndPasswordEvent(email: email, password: password));
    });
  });

  group('signUp', () {
    late SignUpBloc signUpBloc;
    late MockSignUp mockSignUp;

    setUp(() {
      mockSignUp = MockSignUp();
      signUpBloc = SignUpBloc(signUp: mockSignUp);
    });
    test('initialState should be empty SignUpInitial', () {
      // assert
      expect(signUpBloc.state, equals(SignUpInitial()));
    });

    test('should sign up user via sign up use case', () async {
      when(mockSignUp(any)).thenAnswer((_) async => const Right(unit));
      signUpBloc.add(SignUpNewUser(email: email, password: password));
      await untilCalled(mockSignUp(any));
      verify(mockSignUp(const AuthParams(email: email, password: password)));
    });

    test(
        'should emit [SignUpLoading, SignUpLoaded] when signing up was successfully',
        () async {
      when(mockSignUp(any)).thenAnswer((_) async => const Right(unit));

      final expectedStates = [
        SignUpLoading(),
        SignUpLoaded(),
      ];

      expectLater(signUpBloc.stream, emitsInOrder(expectedStates));

      signUpBloc.add(SignUpNewUser(email: email, password: password));
    });

    test(
        'should emit [SignUpLoading, SignUpError] when signing in was unsuccessfully',
        () async {
      when(mockSignUp(any))
          .thenAnswer((_) async => Left(DataBaseFailure(message: 'DB error')));

      final expectedStates = [
        SignUpLoading(),
        const SignUpError(message: 'DB error')
      ];

      expectLater(signUpBloc.stream, emitsInOrder(expectedStates));

      signUpBloc.add(SignUpNewUser(email: email, password: password));
    });
  });

  group('GetSignedInUser', () {
    late SignedInUserBloc signedInUserBloc;
    late MockGetSignedInUser mockGetSignedInUser;
    const tUserEntity =
        UserEntity(id: '123', email: 'email@test.com', phone: '123');

    setUp(() {
      mockGetSignedInUser = MockGetSignedInUser();
      signedInUserBloc = SignedInUserBloc(getUser: mockGetSignedInUser);
    });
    test('initialState should be empty SignUpInitial', () {
      // assert
      expect(signedInUserBloc.state, equals(SignedInUserInitial()));
    });

    test('should get user via sign up use case', () async {
      when(mockGetSignedInUser(any))
          .thenAnswer((_) async => const Right(tUserEntity));
      signedInUserBloc.add(SignedInUser());
      await untilCalled(mockGetSignedInUser(any));
      verify(mockGetSignedInUser(NoParams()));
    });

    test(
        'should emit [SignedInUserLoading, SignedInUserLoaded] when getting user was successfully',
        () async {
      when(mockGetSignedInUser(any))
          .thenAnswer((_) async => const Right(tUserEntity));

      final expectedStates = [
        SignedInUserLoading(),
        const SignedInUserLoaded(user: tUserEntity),
      ];

      expectLater(signedInUserBloc.stream, emitsInOrder(expectedStates));
      signedInUserBloc.add(SignedInUser());
    });

    test(
        'should emit SignedInUserLoaded without user when user doesn\'t exists',
        () async {
      when(mockGetSignedInUser(any)).thenAnswer((_) async => const Right(null));

      final expectedState = [
        SignedInUserLoading(),
        const SignedInUserLoaded(user: null),
      ];

      expectLater(signedInUserBloc.stream, emitsInOrder(expectedState));
      signedInUserBloc.add(SignedInUser());
    });

    test(
        'should emit [SignedInUserLoaded, SignedInUserError] when gettinf user was unsuccessful',
        () async {
      when(mockGetSignedInUser(any))
          .thenAnswer((_) async => Left(DataBaseFailure(message: 'DB error')));

      final expectedStates = [
        SignedInUserLoading(),
        const SignedInUserError(message: 'DB error')
      ];

      expectLater(signedInUserBloc.stream, emitsInOrder(expectedStates));

      signedInUserBloc.add(SignedInUser());
    });
  });
}
