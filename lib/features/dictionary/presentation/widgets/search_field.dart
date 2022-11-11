import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    required this.onSearchHanler,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final void Function() onSearchHanler;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
      ],
      controller: controller,
      textInputAction: TextInputAction.search,
      textAlignVertical: TextAlignVertical.center,
      onSubmitted: (_) => onSearchHanler(),
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          onPressed: onSearchHanler,
          child: const Text('Find!'),
        ),
      ),
    );
  }
}
