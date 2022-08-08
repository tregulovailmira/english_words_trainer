import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/auth_required_state.dart';
import '../bloc/words_list_bloc.dart';
import '../widgets/guess_word_form.dart';

Random random = Random();

class FromEnglishModePage extends StatefulWidget {
  const FromEnglishModePage({Key? key}) : super(key: key);

  @override
  FromEnglishModePageState createState() => FromEnglishModePageState();
}

class FromEnglishModePageState extends AuthRequiredState<FromEnglishModePage> {
  int wordIndex = -1;

  @override
  void initState() {
    super.initState();

    _getWordIndexForRender();
  }

  void _getWordIndexForRender() {
    final words = context.read<WordsListBloc>().state.words;
    setState(() {
      wordIndex = words.isNotEmpty ? random.nextInt(words.length) : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordsListBloc, WordsListState>(
      builder: (context, state) {
        return wordIndex >= 0
            ? GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    _getWordIndexForRender();
                  }
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('English mode'),
                  ),
                  body: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.words[wordIndex].englishWord,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 40,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          GuessWordForm(
                            onSubmit: _getWordIndexForRender,
                            guessWordOrPhrase:
                                state.words[wordIndex].translation,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : const Center(child: Text('No words added yet'));
      },
    );
  }
}
