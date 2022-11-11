import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/components/auth_required_state.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/progres_circle.dart';
import '../../provider/providers.dart';
import '../../provider/state.dart';
import '../widgets/search_field.dart';
import '../widgets/word_card.dart';

class Dictionary extends StatefulWidget {
  const Dictionary({super.key});

  @override
  AuthRequiredState<Dictionary> createState() => _DictionaryState();
}

class _DictionaryState extends AuthRequiredState<Dictionary> {
  void Function() onSearchHandler(WidgetRef ref, BuildContext context) => () {
        final word = ref.watch(searchEditingController).text;
        final isLoading = ref.watch(dictionaryNotifierProvider).isLoading;

        if (word.isNotEmpty && !isLoading) {
          ref
              .read(dictionaryNotifierProvider.notifier)
              .getWordDescription(word);

          FocusScope.of(context).unfocus();
        }
      };

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final state = ref.watch(dictionaryNotifierProvider);
        final searchController = ref.watch(searchEditingController);

        ref.listen(dictionaryNotifierProvider,
            (DictionaryState? previous, DictionaryState current) {
          if (current.isError) {
            context.showErrorSnackBar(message: current.errorMessage!);
          }
        });

        return Scaffold(
          appBar: const CustomAppBar(
            title: 'Dictionary',
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SearchField(
                  controller: searchController,
                  onSearchHanler: onSearchHandler(ref, context),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (state.isLoading)
                  ProgressCircle(
                    color: Theme.of(context).colorScheme.primary,
                    size: 50,
                  ),
                if (state.word != null && !state.isLoading)
                  WordCard(word: state.word!)
              ],
            ),
          ),
        );
      },
    );
  }
}
