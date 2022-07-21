abstract class StringValidator {
  bool isValid(String str);
}

class EmailValidator implements StringValidator {
  static const pattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  @override
  bool isValid(String email) {
    return RegExp(pattern).hasMatch(email);
  }
}

class PasswordValidator implements StringValidator {
  @override
  bool isValid(String password) {
    return password.length > 6;
  }
}
