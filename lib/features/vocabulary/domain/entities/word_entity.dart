import 'package:equatable/equatable.dart';

class WordEntity extends Equatable {
  const WordEntity({
    required this.id,
    required this.userId,
    required this.englishWord,
    required this.translation,
    required this.meanings,
    required this.createdAt,
    this.listeningUrl,
  });

  final int id;
  final String userId;
  final String englishWord;
  final String translation;
  final String? listeningUrl;
  final List<String> meanings;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        userId,
        englishWord,
        translation,
        listeningUrl,
        meanings,
        createdAt,
      ];
}
