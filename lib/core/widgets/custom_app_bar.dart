import 'package:flutter/material.dart';

import '../../routes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  static const _height = 55.0;

  const CustomAppBar({required this.title, Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.profile,
                    (route) => false,
                  );
                },
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.book),
                title: const Text('My Vocabulary'),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.myVocabulary,
                    (route) => false,
                  );
                },
              ),
            ),
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.sports_handball),
                title: const Text('Trainer'),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.trainer,
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
