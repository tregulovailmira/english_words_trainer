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

class AddWordEvent extends WordsListEvent {
  final Map<String, dynamic> word;

  const AddWordEvent(this.word);

  @override
  List<Object> get props => [word];
}

class UpdateWordEvent extends WordsListEvent {
  final int id;
  final String updatedEnglishWord;
  final String updatedTranslation;

  const UpdateWordEvent({
    required this.id,
    required this.updatedEnglishWord,
    required this.updatedTranslation,
  });

  @override
  List<Object> get props => [id, updatedEnglishWord, updatedTranslation];
}

class DeleteWordEvent extends WordsListEvent {
  final int wordId;

  const DeleteWordEvent(this.wordId);

  @override
  List<Object> get props => [wordId];
}
