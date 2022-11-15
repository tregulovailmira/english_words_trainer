import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './state.dart';
import '../../../../core/errors/failures.dart';
import '../../../core/usecases/usecase_sync.dart';
import '../domain/entities/word_description.dart';
import '../domain/usecases/cancel_request.dart';
import '../domain/usecases/get_word_from_dictionary.dart';

class DictionaryNotifier extends StateNotifier<DictionaryState> {
  final GetWordFromDictionary getWordFromDictionary;
  final CancelRequest cancelRequest;

  DictionaryNotifier({
    required this.getWordFromDictionary,
    required this.cancelRequest,
  }) : super(const DictionaryState());

  Future<void> getWordDescription(String word) async {
    state = const DictionaryState(isLoading: true);
    final wordOrFailure = await getWordFromDictionary(
      GetWordParams(
        word: word,
      ),
    );
    if (mounted) {
      state = _getResultOrFailure(wordOrFailure);
    }
  }

  void revokeRequest() {
    cancelRequest(NoParams());
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ApiFailure:
        return (failure as ApiFailure).message;
      default:
        return failure.toString();
    }
  }

  DictionaryState _getResultOrFailure(
    Either<Failure, WordDescription> wordOrFailure,
  ) {
    return wordOrFailure.fold(
      (failure) => DictionaryState(
        isError: true,
        errorMessage: _mapFailureToMessage(failure),
      ),
      (result) => DictionaryState(isLoading: false, word: result),
    );
  }
}
