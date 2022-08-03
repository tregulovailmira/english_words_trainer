part of 'words_list_bloc.dart';

class WordsListState extends Equatable {
  final String? errorMessage;
  final bool isError;
  final bool isLoading;
  final List<WordEntity> words;

  const WordsListState({
    this.errorMessage,
    this.isError = false,
    this.isLoading = false,
    this.words = const [],
  });

  @override
  List<Object?> get props => [errorMessage, isLoading, isError, words];
}
