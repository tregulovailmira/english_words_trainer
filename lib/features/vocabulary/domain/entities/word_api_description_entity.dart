import 'package:equatable/equatable.dart';

class WordApiDescriptionEntity extends Equatable {
  const WordApiDescriptionEntity({
    required this.word,
    required this.meanings,
    this.listeningUrl,
  });

  final String word;
  final String? listeningUrl;
  final List<String> meanings;

  @override
  List<Object?> get props => [word, listeningUrl, meanings];
}
