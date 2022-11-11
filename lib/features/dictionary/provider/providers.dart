import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './notifier.dart';
import './state.dart';
import '../../../core/dio/interceptors/dictionary_auth_interceptor.dart';
import '../../../core/dio/interceptors/retry_interceptor.dart';
import '../../../core/dio/utils/request_retrier.dart';
import '../data/datasources/dictionary_datasource.dart';
import '../data/repositories/dictionary_repository_impl.dart';
import '../domain/repositories/dictionary_repository.dart';
import '../domain/usecases/get_word_from_dictionary.dart';

//! External
final dioProvider = Provider<Dio>((ref) => Dio());
final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

//! Core
final authInterceptorProvider =
    Provider<Interceptor>((ref) => DictionaryAuthInterceptor());

final requestRetrier = Provider<DioConnectivityRequestRetrier>(
  (ref) => DioConnectivityRequestRetrier(
    dio: ref.read(dioProvider),
    connectivity: ref.read(connectivityProvider),
  ),
);

final retryInterceptor = Provider<Interceptor>(
  (ref) => RetryOnConnectionChangeInterceptor(
    requestRetrier: ref.read(requestRetrier),
  ),
);

//! Data source
final dictionaryDataSourceProvider = Provider<DictionaryDataSource>(
  (ref) => DictionaryDataSourceImpl(
    client: ref.read(dioProvider),
    interceptors: [
      ref.read(authInterceptorProvider),
      ref.read(retryInterceptor),
    ],
  ),
);

//! Repository
final dictionaryRepositoryProvider = Provider<DictionaryRepository>(
  (ref) => DictionaryRepositoryImpl(ref.read(dictionaryDataSourceProvider)),
);

//! Usecase
final getDescriptionUsecaseProvider = Provider<GetWordFromDictionary>(
  (ref) => GetWordFromDictionary(ref.read(dictionaryRepositoryProvider)),
);

//! State Notifier
final dictionaryNotifierProvider =
    StateNotifierProvider<DictionaryNotifier, DictionaryState>(
  (ref) => DictionaryNotifier(ref.read(getDescriptionUsecaseProvider)),
);

//! Presentation
final searchEditingController = Provider(((ref) => TextEditingController()));
