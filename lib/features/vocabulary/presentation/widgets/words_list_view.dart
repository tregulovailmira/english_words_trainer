import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './add_new_word_form.dart';
import './word_audio_player.dart';
import '../../domain/entities/word_entity.dart';
import '../bloc/words_list_bloc.dart';

class WordsListView extends StatelessWidget {
  WordsListView({required this.wordsList, Key? key}) : super(key: key);

  final List<WordEntity> wordsList;
  final englishWordController = TextEditingController();
  final translationController = TextEditingController();

  static const englishTextStyle = TextStyle(
    fontSize: 20,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const translationTextStyle = TextStyle(
    fontSize: 15,
    color: Colors.grey,
  );

  _openEditForm(BuildContext blocContext, WordEntity wordToUpdate) {
    englishWordController.text = wordToUpdate.englishWord;
    translationController.text = wordToUpdate.translation;

    showDialog(
      context: blocContext,
      builder: (_) => AddOrEditWordForm(
        word: wordToUpdate,
        blocContext: blocContext,
        englishWordController: englishWordController,
        translationController: translationController,
        onSubmit: onUpdateHandler(blocContext, wordToUpdate),
        title: 'Edit word',
      ),
    );
  }

  onUpdateHandler(BuildContext blocContext, WordEntity wordToUpdate) => () {
        blocContext.read<WordsListBloc>().add(
              UpdateWordEvent(
                id: wordToUpdate.id,
                updatedEnglishWord: englishWordController.text,
                updatedTranslation: translationController.text,
              ),
            );
      };

  @override
  Widget build(BuildContext context) {
    if (wordsList.isNotEmpty) {
      return ListView.separated(
        itemCount: wordsList.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: <Widget>[
              PopupMenuButton(
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  const PopupMenuItem(
                    value: 'edit',
                    padding: EdgeInsets.all(0),
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    padding: EdgeInsets.all(0),
                    child: ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Delete'),
                    ),
                  ),
                ],
                onSelected: (selection) {
                  switch (selection) {
                    case 'edit':
                      _openEditForm(context, wordsList[index]);
                      break;
                    case 'delete':
                      context
                          .read<WordsListBloc>()
                          .add(DeleteWordEvent(wordsList[index].id));
                      break;
                  }
                },
              ),
              Expanded(
                child: Column(
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
                ),
              ),
              wordsList[index].listeningUrl != null
                  ? WordAudioPlayer(
                      audioUrl: wordsList[index].listeningUrl!,
                    )
                  : const SizedBox(
                      width: 50,
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
        ),
      );
    }
  }
}
