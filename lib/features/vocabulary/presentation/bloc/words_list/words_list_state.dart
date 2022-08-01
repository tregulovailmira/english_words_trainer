part of 'words_list_bloc.dart';

abstract class WordsListState extends Equatable {
  const WordsListState();

  @override
  List<Object?> get props => [];
}

class WordsListInitial extends WordsListState {}

class WordsListLoading extends WordsListState {}

class WordsListError extends WordsListState {
  final String message;

  const WordsListError({required this.message});

  @override
  List<Object> get props => [message];
}

class WordsListLoaded extends WordsListState {
  final List<WordEntity> words;

  const WordsListLoaded({required this.words});

  @override
  List<Object> get props => [words];
}
