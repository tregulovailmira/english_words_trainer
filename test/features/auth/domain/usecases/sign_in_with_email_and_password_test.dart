import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/usecases/usecase.dart';
import 'package:english_words_trainer/features/auth/domain/repositories/auth_repository.dart';
import 'package:english_words_trainer/features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/auth_repository.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepositry mockAuthRepositry;
  late SignInWithEmailAndPassword usecase;

  setUp(() {
    mockAuthRepositry = MockAuthRepositry();
    usecase = SignInWithEmailAndPassword(mockAuthRepositry);
  });

  test(
    'should sign in user with credentials via repository',
    () async {
      const email = 'test@test.com';
      const password = 'secretPassword';
      // "On the fly" implementation of the Repository using the Mockito package.
      // When getConcreteNumberTrivia is called with any argument, always answer with
      // the Right "side" of Either containing a test NumberTrivia object.
      when(mockAuthRepositry.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => const Right(unit));
      // The "act" phase of the test. Call the not-yet-existent method.
      final result =
          await usecase(const AuthParams(email: email, password: password));
      // UseCase should simply return whatever was returned from the Repository
      expect(result, const Right(unit));
      // Verify that the method has been called on the Repository
      verify(mockAuthRepositry.signInWithEmailAndPassword(
          email: email, password: password));
      // Only the above method should be called and nothing more.
      verifyNoMoreInteractions(mockAuthRepositry);
    },
  );
}
