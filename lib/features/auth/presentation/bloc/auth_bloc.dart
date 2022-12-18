import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_signed_in_user.dart';
import '../../domain/usecases/sign_in_with_email_and_password.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthUserState> {
  final SignInWithEmailAndPassword signInWithEmailAndPassword;
  final SignUp signUp;
  final GetSignedInUser getUser;
  final SignOut signOut;

  AuthUserState get initialState => AuthInitial();

  AuthBloc({
    required SignInWithEmailAndPassword signIn,
    required this.signUp,
    required this.getUser,
    required this.signOut,
  })  : signInWithEmailAndPassword = signIn,
        super(AuthInitial()) {
    on<SignInWithEmailAndPasswordEvent>((event, emit) async {
      emit(AuthLoading());

      final failureOrUnit = await signInWithEmailAndPassword(
        AuthParams(email: event.email, password: event.password),
      );

      emit(_getLoadedOrErrorState(failureOrUnit));
    });

    on<SignUpNewUser>((event, emit) async {
      emit(AuthLoading());

      final failureOrUnit = await signUp(
        AuthParams(email: event.email, password: event.password),
      );

      emit(_getLoadedOrErrorState(failureOrUnit));
    });

    on<SignedInUser>((event, emit) async {
      emit(AuthLoading());

      final failureOrUserEntity = await getUser(NoParams());

      emit(_getLoadedOrErrorState(failureOrUserEntity));
    });
    on<SignOutEvent>((event, emit) async {
      emit(AuthLoading());

      await signOut(NoParams());
      emit(AuthInitial());
    });
  }

  AuthUserState _getLoadedOrErrorState(failureOrResult) => failureOrResult.fold(
        (failure) => AuthError(message: _mapFailureToMessage(failure)),
        (result) {
          if (result is UserEntity) {
            return AuthLoaded(user: result);
          } else {
            return const AuthLoaded();
          }
        },
      );

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case DataBaseFailure:
        return (failure as DataBaseFailure).message;
      default:
        return 'Unexpected Error';
    }
  }
}
