import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../domain/entities/word_entity.dart';
import '../../domain/usecases/add_new_word.dart';
import '../../domain/usecases/delete_word.dart';
import '../../domain/usecases/get_words_list.dart';
import '../../domain/usecases/update_word.dart';

part './words_list_event.dart';
part './words_list_state.dart';

class WordsListBloc extends Bloc<WordsListEvent, WordsListState> {
  final GetWordsList getWordsList;
  final AddNewWord addNewWord;
  final UpdateWord updateWord;
  final DeleteWord deleteWord;

  WordsListBloc({
    required this.getWordsList,
    required this.addNewWord,
    required this.updateWord,
    required this.deleteWord,
  }) : super(const WordsListState()) {
    on<GetWordsEvent>((event, emit) async {
      emit(const WordsListState(isLoading: true));

      final wordsOfFailure =
          await getWordsList(GetWordsParams(userId: event.userId));

      emit(_getLoadedOrErrorState(wordsOfFailure, state, event));
    });

    on<AddWordEvent>(
      (event, emit) async {
        emit(WordsListState(isLoading: true, words: state.words));

        final wordOrFailure =
            await addNewWord(AddNewWordParams(word: event.word));

        emit(_getLoadedOrErrorState(wordOrFailure, state, event));
      },
    );

    on<UpdateWordEvent>((event, emit) async {
      emit(WordsListState(isLoading: true, words: state.words));

      final wordOrFailure = await _getUpdatedWordOrFailure(event);

      emit(_getLoadedOrErrorState(wordOrFailure, state, event));
    });

    on<DeleteWordEvent>((event, emit) async {
      emit(WordsListState(isLoading: true, words: state.words));

      final unitOrFailure = await deleteWord(
        DeleteWordParams(id: event.wordId),
      );

      emit(_getLoadedOrErrorState(unitOrFailure, state, event));
    });
  }

  WordsListState _getLoadedOrErrorState(
    Either<Failure, dynamic> failureOrResult,
    WordsListState prevState,
    WordsListEvent event,
  ) {
    return failureOrResult.fold(
      (failure) => _getErrorState(failure, prevState),
      (result) => _getLoadedState(result, prevState, event),
    );
  }

  WordsListState _getErrorState(Failure failure, [WordsListState? prevState]) =>
      WordsListState(
        errorMessage: _mapFailureToMessage(failure),
        isError: true,
        isLoading: false,
        words: prevState != null ? prevState.words : [],
      );

  WordsListState _getLoadedState(
    dynamic result,
    WordsListState prevState,
    WordsListEvent event,
  ) {
    List<WordEntity> words = [];

    switch (event.runtimeType) {
      case GetWordsEvent:
        words = result;
        break;
      case AddWordEvent:
        words = [...prevState.words, result];
        break;
      case UpdateWordEvent:
        words = state.words
            .map((word) => word.id == result.id ? result as WordEntity : word)
            .toList();
        break;
      case DeleteWordEvent:
        words = state.words
            .where((word) => word.id != (event as DeleteWordEvent).wordId)
            .toList();
        break;
    }

    return WordsListState(
      isError: false,
      errorMessage: null,
      isLoading: false,
      words: words,
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case DataBaseFailure:
        return (failure as DataBaseFailure).message;
      default:
        return 'Unexpected Error';
    }
  }

  Future<Either<Failure, WordEntity>> _getUpdatedWordOrFailure(
    UpdateWordEvent event,
  ) {
    final foundWord = state.words.firstWhere(
      (word) => word.id == event.id,
    );

    final wordToUpdate = WordEntity(
      id: foundWord.id,
      userId: foundWord.userId,
      englishWord: event.updatedEnglishWord,
      translation: event.updatedTranslation,
      createdAt: foundWord.createdAt,
    );
    return updateWord(
      UpdateWordParams(word: wordToUpdate),
    );
  }
}
