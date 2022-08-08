import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/word_entity.dart';
import '../../domain/usecases/add_new_word.dart';
import '../../domain/usecases/get_words_list.dart';

part './words_list_event.dart';
part './words_list_state.dart';

class WordsListBloc extends Bloc<WordsListEvent, WordsListState> {
  final GetWordsList getWordsList;
  final AddNewWord addNewWord;

  WordsListBloc({required this.getWordsList, required this.addNewWord})
      : super(const WordsListState()) {
    on<GetWordsEvent>((event, emit) async {
      emit(const WordsListState(isLoading: true));

      final wordsOfFailure =
          await getWordsList(GetWordsParams(userId: event.userId));

      emit(_getLoadedOrErrorState(wordsOfFailure));
    });

    on<AddWordEvent>(
      ((event, emit) async {
        emit(WordsListState(isLoading: true, words: state.words));

        final wordOrFailure =
            await addNewWord(AddNewWordParams(word: event.word));

        emit(_getLoadedOrErrorState(wordOrFailure, state));
      }),
    );
  }

  WordsListState _getLoadedOrErrorState(
    Either<Failure, dynamic> failureOrResult, [
    WordsListState? prevState,
  ]) {
    return failureOrResult.fold(
      (failure) => _getErrorState(failure, prevState),
      (result) => _getLoadedState(result, prevState),
    );
  }

  WordsListState _getErrorState(Failure failure, [WordsListState? prevState]) =>
      WordsListState(
        errorMessage: _mapFailureToMessage(failure),
        isError: true,
        isLoading: false,
        words: prevState != null ? prevState.words : [],
      );

  WordsListState _getLoadedState(dynamic result, [WordsListState? prevState]) =>
      WordsListState(
        isError: false,
        errorMessage: null,
        isLoading: false,
        words: prevState != null ? [...prevState.words, result] : result,
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
