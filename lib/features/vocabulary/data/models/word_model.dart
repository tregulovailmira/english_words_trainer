import '../../domain/entities/word_entity.dart';

class WordModel extends WordEntity {
  const WordModel({
    required int id,
    required String userId,
    required String englishWord,
    required String translation,
    required DateTime createdAt,
  }) : super(
          id: id,
          userId: userId,
          englishWord: englishWord,
          translation: translation,
          createdAt: createdAt,
        );

  factory WordModel.fromMap(Map<String, dynamic> word) {
    return WordModel(
      id: word['id'],
      userId: word['userId'],
      englishWord: word['englishWord'],
      translation: word['translation'],
      createdAt: DateTime.parse(word['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'englishWord': englishWord,
      'translation': translation,
    };
  }
}
