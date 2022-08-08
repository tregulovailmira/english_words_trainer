import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/components/auth_required_state.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../bloc/words_list_bloc.dart';
import '../widgets/add_new_word_form.dart';
import '../widgets/vocabulary_list.dart';

class MyVocabularyPage extends StatefulWidget {
  const MyVocabularyPage({Key? key}) : super(key: key);

  @override
  MyVocabularyPageState createState() => MyVocabularyPageState();
}

class MyVocabularyPageState extends AuthRequiredState<MyVocabularyPage> {
  String userId = '';

  @override
  void onAuthenticated(Session session) {
    setState(() {
      userId = session.user!.id;
    });
  }

  _openForm(blocContext, isLoading, isError) => () {
        showDialog(
          context: blocContext,
          builder: (_) => AddNewWordForm(
            userId: userId,
            blocContext: blocContext,
            isLoading: isLoading,
          ),
        );
      };

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WordsListBloc, WordsListState>(
      listener: (context, state) {
        if (state.isError) {
          context.showErrorSnackBar(message: state.errorMessage!);
        }
      },
      builder: (blocContext, state) => Scaffold(
        appBar: const CustomAppBar(
          title: 'Vocabulary',
        ),
        body: const VocabularyList(),
        floatingActionButton: FloatingActionButton(
          onPressed: _openForm(blocContext, state.isLoading, state.isError),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
