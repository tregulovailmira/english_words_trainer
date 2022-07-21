part of 'auth_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent([props]);

  @override
  List<Object> get props => [props];
}

class SignInWithEmailAndPasswordEvent extends SignInEvent {
  final String email;
  final String password;

  SignInWithEmailAndPasswordEvent({required this.email, required this.password})
      : super([email, password]);
}

abstract class SignUpEvent extends Equatable {
  const SignUpEvent([props]);

  @override
  List<Object> get props => [props];
}

class SignUpNewUser extends SignUpEvent {
  final String email;
  final String password;

  SignUpNewUser({required this.email, required this.password})
      : super([email, password]);
}

abstract class SignedInUserEvent extends Equatable {
  const SignedInUserEvent([props]);

  @override
  List<Object> get props => [props];
}

class SignedInUser extends SignedInUserEvent {}
