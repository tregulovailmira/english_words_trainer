import 'package:flutter_riverpod/flutter_riverpod.dart';

import './state.dart';
import '../../../../core/errors/failures.dart';
import '../domain/usecases/get_word_from_dictionary.dart';

class DictionaryNotifier extends StateNotifier<DictionaryState> {
  final GetWordFromDictionary getWordFromDictionary;

  DictionaryNotifier(this.getWordFromDictionary)
      : super(const DictionaryState());

  Future<void> getWordDescription(String word) async {
    state = const DictionaryState(isLoading: true);
    state = await _getResultOrFailure(word);
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ApiFailure:
        return (failure as ApiFailure).message;
      default:
        return failure.toString();
    }
  }

  Future<DictionaryState> _getResultOrFailure(String word) async {
    final wordOrFailure = await getWordFromDictionary(
      GetWordParams(
        word: word,
      ),
    );

    return wordOrFailure.fold(
      (failure) => DictionaryState(
        isError: true,
        errorMessage: _mapFailureToMessage(failure),
      ),
      (result) => DictionaryState(isLoading: false, word: result),
    );
  }
}
