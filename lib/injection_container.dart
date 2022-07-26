import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './features/auth/presentation/bloc/auth_bloc.dart';
import './features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import './features/auth/domain/usecases/sign_up.dart';
import './features/auth/domain/usecases/get_signed_in_user.dart';
import './features/auth/domain/repositories/auth_repository.dart';
import './features/auth/data/repositories/auth_repository_impl.dart';
import './features/auth/data/datasources/db_datasource.dart';
import './core/utils/validatior.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth

  // Bloc
  sl.registerFactory(
    () => SignInBloc(signIn: sl()),
  );

  sl.registerFactory(
    () => SignUpBloc(signUp: sl()),
  );

  sl.registerFactory(
    () => SignedInUserBloc(getUser: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => SignInWithEmailAndPassword(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => GetSignedInUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<DbDataSource>(
    () => DbDataSourceImpl(client: sl()),
  );

  //! Core
  sl.registerLazySingleton<StringValidator>(() => EmailValidator());
  // sl.registerLazySingleton<StringValidator>(() => PasswordValidator());

  //! External
  sl.registerLazySingleton(() => Supabase.instance.client);
}
