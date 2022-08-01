import 'package:english_words_trainer/features/vocabulary/domain/entities/word_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../domain/usecases/get_words_list.dart';

part './words_list_event.dart';
part './words_list_state.dart';

class WordsListBloc extends Bloc<WordsListEvent, WordsListState> {
  final GetWordsList getWordsList;
  WordsListBloc(this.getWordsList) : super(WordsListInitial()) {
    on<GetWordsEvent>((event, emit) async {
      emit(WordsListLoading());
      final wordsOfFailure = await getWordsList(Params(userId: event.userId));
      emit(wordsOfFailure.fold(
        (failure) => WordsListError(message: _mapFailureToMessage(failure)),
        (words) => WordsListLoaded(words: words),
      ));
    });
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
