part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent([props]);

  @override
  List<Object> get props => [props];
}

class SignInWithEmailAndPasswordEvent extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmailAndPasswordEvent({
    required this.email,
    required this.password,
  }) : super([email, password]);

  @override
  List<Object> get props => [email, password];
}

class SignUpNewUser extends AuthEvent {
  final String email;
  final String password;

  SignUpNewUser({required this.email, required this.password})
      : super([email, password]);
}

class SignedInUser extends AuthEvent {}

class SignOutEvent extends AuthEvent {}
