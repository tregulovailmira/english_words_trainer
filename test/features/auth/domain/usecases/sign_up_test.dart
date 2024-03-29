import 'package:dartz/dartz.dart';
import 'package:english_words_trainer/core/usecases/usecase.dart';
import 'package:english_words_trainer/features/auth/domain/repositories/auth_repository.dart';
import 'package:english_words_trainer/features/auth/domain/usecases/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './sign_up_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late SignUp usecase;
  late MockAuthRepository mockAuthRepositry;

  setUp(() {
    mockAuthRepositry = MockAuthRepository();
    usecase = SignUp(mockAuthRepositry);
  });

  test('should register user calling repository', () async {
    const email = 'test@test.com';
    const password = 'secretPassword';

    when(
      mockAuthRepositry.signUp(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenAnswer((_) async => const Right(unit));

    final result =
        await usecase(const AuthParams(email: email, password: password));

    expect(result, equals(const Right(unit)));

    verify(mockAuthRepositry.signUp(email: email, password: password));
    verifyNoMoreInteractions(mockAuthRepositry);
  });
}
