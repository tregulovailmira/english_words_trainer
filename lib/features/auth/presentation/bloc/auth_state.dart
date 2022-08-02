part of 'auth_bloc.dart';

// SignIn State

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class SignInLoaded extends SignInState {}

class SignInError extends SignInState {
  final String message;

  const SignInError({required this.message});

  @override
  List<Object> get props => [message];
}

// SignUp State

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpLoaded extends SignUpState {}

class SignUpError extends SignUpState {
  final String message;

  const SignUpError({required this.message});

  @override
  List<Object> get props => [message];
}

// Signed in user state

abstract class SignedInUserState extends Equatable {
  const SignedInUserState();

  @override
  List<Object?> get props => [];
}

class SignedInUserInitial extends SignedInUserState {}

class SignedInUserLoading extends SignedInUserState {}

class SignedInUserLoaded extends SignedInUserState {
  final UserEntity? user;

  const SignedInUserLoaded({this.user});

  @override
  List<Object?> get props => [user];
}

class SignedInUserError extends SignedInUserState {
  final String message;

  const SignedInUserError({required this.message});

  @override
  List<Object?> get props => [message];
}
