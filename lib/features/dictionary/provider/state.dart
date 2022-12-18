import 'package:equatable/equatable.dart';

import '../domain/entities/word_description.dart';

class DictionaryState extends Equatable {
  final bool isError;
  final bool isLoading;
  final WordDescription? word;
  final String? errorMessage;

  const DictionaryState({
    this.isError = false,
    this.isLoading = false,
    this.word,
    this.errorMessage,
  });

  DictionaryState copyWith({
    bool? isError,
    bool? isLoading,
    WordDescription? word,
    String? errorMessage,
  }) {
    return DictionaryState(
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      word: word ?? this.word,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, isError, word, errorMessage];
}
