import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/components/auth_required_state.dart';
import '../../../../core/widgets/error_message.dart';
import '../../../../core/widgets/progres_circle.dart';
import '../bloc/words_list/words_list_bloc.dart';
import './words_list_view.dart';

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
