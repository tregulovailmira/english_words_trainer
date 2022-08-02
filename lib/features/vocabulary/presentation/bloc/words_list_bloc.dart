import 'package:english_words_trainer/features/vocabulary/domain/entities/word_entity.dart';
import 'package:english_words_trainer/features/vocabulary/domain/usecases/add_new_word.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
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
      emit(wordsOfFailure.fold(
        (failure) => WordsListState(
          errorMessage: _mapFailureToMessage(failure),
          isError: true,
          isLoading: false,
        ),
        (words) {
          return WordsListState(
            isError: false,
            errorMessage: null,
            isLoading: false,
            words: words,
          );
        },
      ));
    });

    on<AddWordEvent>(((event, emit) async {
      emit(WordsListState(isLoading: true, words: state.words));
      final wordOrFailure =
          await addNewWord(AddNewWordParams(word: event.word));
      emit(wordOrFailure.fold(
        (failure) => WordsListState(
          isError: true,
          errorMessage: _mapFailureToMessage(failure),
          isLoading: false,
          words: state.words,
        ),
        (word) => WordsListState(
          isError: false,
          errorMessage: null,
          isLoading: false,
          words: [...state.words, word],
        ),
      ));
    }));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case DataBaseFailure:
        return (failure as DataBaseFailure).message;
      default:
        return 'Unexpected Error';
    }
  }
}
