import 'package:english_words_trainer/core/utils/validatior.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('email validation', () {
    late EmailValidator emailValidator;

    setUp(() {
      emailValidator = EmailValidator();
    });

    test('should return true if email is valid', () {
      const validEmail = 'test@test.com';
      final result = emailValidator.isValid(validEmail);
      expect(result, true);
    });

    test('should return false if email is invalid', () {
      const invalidEmail = 'testtest.com';
      final result = emailValidator.isValid(invalidEmail);
      expect(result, false);
    });
  });

  group('password validation', () {
    late PasswordValidator passwordValidator;

    setUp(() {
      passwordValidator = PasswordValidator();
    });

    test('should return true if password is valid', () {
      const validPassword = 'testPassword';
      final result = passwordValidator.isValid(validPassword);
      expect(result, true);
    });

    test('should return false if password is invalid', () {
      const invalidPassword = 'pass';
      final result = passwordValidator.isValid(invalidPassword);
      expect(result, false);
    });
  });
}
