import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/components/auth_required_state.dart';
import '../../../../core/widgets/progres_circle.dart';
import '../../../../injection_container.dart' as di;
import '../../../../core/widgets/error_message.dart';
import '../../domain/entities/word_entity.dart';
import '../bloc/words_list/words_list_bloc.dart';

class MyVocabularyPage extends StatefulWidget {
  const MyVocabularyPage({Key? key}) : super(key: key);

  @override
  MyVocabularyPageState createState() => MyVocabularyPageState();
}

class MyVocabularyPageState extends AuthRequiredState<MyVocabularyPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (blocContext) => di.sl<WordsListBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vocabulary'),
        ),
        body: const VocabularyList(),
      ),
    );
  }
}

class VocabularyList extends StatefulWidget {
  const VocabularyList({Key? key}) : super(key: key);

  @override
  VocabularyListState createState() => VocabularyListState();
}

class VocabularyListState extends AuthRequiredState<VocabularyList> {
  Future<void> _getWords(String userId) async {
    BlocProvider.of<WordsListBloc>(context).add(GetWordsEvent(userId));
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    if (user != null) {
      _getWords(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordsListBloc, WordsListState>(
        builder: (blocContext, state) {
      if (state is WordsListLoading) {
        return ProgressCircle(color: Theme.of(context).colorScheme.primary);
      } else if (state is WordsListError) {
        return ErrorMessage(state.props[0] as String);
      } else if (state is WordsListLoaded) {
        return Padding(
            padding: const EdgeInsets.all(15),
            child: WordsListView(wordsList: state.words));
      } else {
        return const Center(
          child: Text('test'),
        );
      }
    });
  }
}

class WordsListView extends StatelessWidget {
  const WordsListView({Key? key, required this.wordsList}) : super(key: key);

  final List<WordEntity> wordsList;

  static const englishTextStyle = TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const translationTextStyle = TextStyle(
    fontSize: 15,
    color: Colors.grey,
  );

  @override
  Widget build(BuildContext context) {
    if (wordsList.isNotEmpty) {
      return ListView.separated(
        itemCount: wordsList.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: <Widget>[
              const Icon(Icons.volume_up_sharp),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wordsList[index].englishWord,
                    style: englishTextStyle,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    wordsList[index].translation,
                    style: translationTextStyle,
                    overflow: TextOverflow.clip,
                  )
                ],
              )
            ],
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      );
    } else {
      return Center(
          child: Text(
        'No words added yet :(',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ));
    }
  }
}
