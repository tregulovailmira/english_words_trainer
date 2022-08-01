import 'package:flutter/material.dart';

import '../../routes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key, required this.title}) : super(key: key);
  final String title;
  static const _height = 55.0;

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
                title: const Text('Account'),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.account, (route) => false);
                },
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.list),
                title: const Text('My Vocabulary'),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      Routes.myVocabulary, (route) => false);
                },
              ),
            ),
          ],
        ),
        // IconButton(onPressed: _openMenu, icon: const Icon(Icons.menu)),
      ],
    );
  }
}
