part of 'words_list_bloc.dart';

abstract class WordsListEvent extends Equatable {
  const WordsListEvent();

  @override
  List<Object> get props => [];
}

class GetWordsEvent extends WordsListEvent {
  final String userId;

  const GetWordsEvent(this.userId);

  @override
  List<Object> get props => [userId];
}
