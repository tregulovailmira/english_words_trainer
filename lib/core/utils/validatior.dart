abstract class StringValidator {
  bool isValid(String str);
  String? validate(String str);
}

class EmailValidator implements StringValidator {
  static const pattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  @override
  bool isValid(String email) {
    return RegExp(pattern).hasMatch(email);
  }

  @override
  String? validate(String email) {
    if (isValid(email)) {
      return null;
    } else {
      return 'Email should be in format: testemail@mail.com';
    }
  }
}

class PasswordValidator implements StringValidator {
  @override
  bool isValid(String password) {
    return password.length > 6;
  }

  @override
  String? validate(String email) {
    if (isValid(email)) {
      return null;
    } else {
      return 'Password length should be more than 6';
    }
  }
}

class CharValidator {
  String? validate(String char, String expectedChar) {
    return char == expectedChar ? null : '';
  }
}
