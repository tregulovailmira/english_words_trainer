import 'package:english_words_trainer/features/auth/domain/usecases/get_signed_in_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:english_words_trainer/core/errors/failures.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/sign_in_with_email_and_password.dart';
import '../../domain/usecases/sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInWithEmailAndPassword signInWithEmailAndPassword;

  SignInState get initialState => SignInInitial();

  SignInBloc({
    required SignInWithEmailAndPassword signIn,
  })  : signInWithEmailAndPassword = signIn,
        super(SignInInitial()) {
    on<SignInWithEmailAndPasswordEvent>((event, emit) async {
      emit(SignInLoading());

      final failureOrUnit = await signInWithEmailAndPassword(
          AuthParams(email: event.email, password: event.password));

      emit(failureOrUnit.fold(
          (failure) => SignInError(message: _mapFailureToMessage(failure)),
          (success) => SignInLoaded()));
    });
  }
}

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUp signUp;

  SignUpState get initialState => SignUpInitial();

  SignUpBloc({required this.signUp}) : super(SignUpInitial()) {
    on<SignUpNewUser>((event, emit) async {
      emit(SignUpLoading());

      final failureOrUnit = await signUp(
          AuthParams(email: event.email, password: event.password));

      emit(failureOrUnit.fold(
          (failure) => SignUpError(message: _mapFailureToMessage(failure)),
          (success) => SignUpLoaded()));
    });
  }
}

class SignedInUserBloc extends Bloc<SignedInUserEvent, SignedInUserState> {
  final GetSignedInUser getUser;

  SignedInUserState get initialState => SignedInUserInitial();

  SignedInUserBloc({required this.getUser}) : super(SignedInUserInitial()) {
    on<SignedInUser>((event, emit) async {
      emit(SignedInUserLoading());
      final either = await getUser(NoParams());
      emit(either.fold(
          (failure) =>
              SignedInUserError(message: _mapFailureToMessage(failure)),
          (user) => SignedInUserLoaded(user: user)));
    });
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case DataBaseFailure:
      return (failure as DataBaseFailure).message;
    default:
      return 'Unexpected Error';
  }
}
