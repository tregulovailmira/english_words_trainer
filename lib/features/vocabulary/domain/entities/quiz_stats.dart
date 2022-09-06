import 'package:equatable/equatable.dart';

import './question.dart';

class QuizStats extends Equatable {
  const QuizStats({
    this.corrects = const [],
    this.wrongs = const [],
    this.noAnswered = const [],
    this.score = 0,
  });

  final List<Question> corrects;
  final List<Question> wrongs;
  final List<Question> noAnswered;
  final int score;

  factory QuizStats.addCorrect(Question question, QuizStats prevStats) {
    return QuizStats(
      corrects: [...prevStats.corrects, question],
      wrongs: prevStats.wrongs,
      noAnswered: prevStats.noAnswered,
      score: prevStats.score + 10,
    );
  }

  factory QuizStats.addWrong(Question question, QuizStats prevStats) {
    return QuizStats(
      wrongs: [
        ...prevStats.wrongs,
        question,
      ],
      corrects: prevStats.corrects,
      noAnswered: prevStats.noAnswered,
      score: prevStats.score - 4,
    );
  }

  factory QuizStats.addNoAnswer(Question question, QuizStats prevStats) {
    return QuizStats(
      noAnswered: [...prevStats.noAnswered, question],
      wrongs: prevStats.wrongs,
      corrects: prevStats.corrects,
      score: prevStats.score - 2,
    );
  }

  @override
  List<Object?> get props => [corrects, wrongs, noAnswered, score];
}
