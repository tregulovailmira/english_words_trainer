import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import './core/utils/validatior.dart';
import './features/auth/data/datasources/db_datasource.dart';
import './features/auth/data/repositories/auth_repository_impl.dart';
import './features/auth/domain/repositories/auth_repository.dart';
import './features/auth/domain/usecases/get_signed_in_user.dart';
import './features/auth/domain/usecases/sign_in_with_email_and_password.dart';
import './features/auth/domain/usecases/sign_up.dart';
import './features/auth/presentation/bloc/auth_bloc.dart';
import './features/vocabulary/domain/usecases/add_new_word.dart';
import './features/vocabulary/domain/usecases/get_words_list.dart';
import './features/vocabulary/presentation/bloc/words_list_bloc.dart';
import 'features/vocabulary/data/datasources/vocabulary_remote_datasource.dart';
import 'features/vocabulary/data/datasources/word_api_datasource.dart';
import 'features/vocabulary/data/repositories/vocabulary_repository_impl.dart';
import 'features/vocabulary/data/repositories/word_description_repositoty_impl.dart';
import 'features/vocabulary/domain/repositories/vocabulary_repository.dart';
import 'features/vocabulary/domain/repositories/word_description_repository.dart';
import 'features/vocabulary/domain/usecases/delete_word.dart';
import 'features/vocabulary/domain/usecases/get_word_description.dart';
import 'features/vocabulary/domain/usecases/update_word.dart';
import 'features/vocabulary/presentation/bloc/quiz/quiz_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      signUp: sl(),
      getUser: sl(),
    ),
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

  //! Features - Vocabulary

  // Bloc
  sl.registerFactory(
    () => WordsListBloc(
      getWordsList: sl(),
      addNewWord: sl(),
      updateWord: sl(),
      deleteWord: sl(),
      getWordDescription: sl(),
    ),
  );

  sl.registerFactory(() => QuizBloc());

  // Usecases
  sl.registerLazySingleton(() => GetWordsList(sl()));
  sl.registerLazySingleton(() => AddNewWord(sl()));
  sl.registerLazySingleton(() => UpdateWord(sl()));
  sl.registerLazySingleton(() => DeleteWord(sl()));
  sl.registerLazySingleton(() => GetWordDescription(sl()));

  // Repository
  sl.registerLazySingleton<VocabularyRepository>(
    () => VocabularyRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<WordDescriptionRepository>(
    () => WordDescriptionRepositoryImpl(sl()),
  );

  // Data Sources
  sl.registerLazySingleton<VocabularyRemoteDataSource>(
    () => VocabularyRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<WordApiDataSource>(
    () => WordApiDataSourceImpl(sl()),
  );

  //! Core
  sl.registerLazySingleton<StringValidator>(() => EmailValidator());
  // sl.registerLazySingleton<StringValidator>(() => PasswordValidator());

  //! External
  sl.registerLazySingleton(() => Supabase.instance.client);
  sl.registerLazySingleton(() => http.Client());
}
