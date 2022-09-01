part of 'auth_bloc.dart';

abstract class AuthUserState extends Equatable {
  const AuthUserState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthUserState {}

class AuthLoading extends AuthUserState {}

class AuthLoaded extends AuthUserState {
  final UserEntity? user;

  const AuthLoaded({this.user});

  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthUserState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}
