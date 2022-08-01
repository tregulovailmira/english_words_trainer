import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/components/auth_required_state.dart';
import '../../../../injection_container.dart' as di;
import '../bloc/words_list/words_list_bloc.dart';
import '../widgets/vocabulary_list.dart';

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
        appBar: const CustomAppBar(
          title: "Vocabulary",
        ),
        body: const VocabularyList(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {}, child: const Icon(Icons.add)),
      ),
    );
  }
}



