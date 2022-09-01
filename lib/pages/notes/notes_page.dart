import 'package:flutter/material.dart';
import 'dart:developer' as dev_tools show log;

import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/enums/note_menu_actions.dart';
import 'package:my_notes/services/auth/services/auth_service.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          _popupMenuButton(),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Notes"),
          ],
        ),
      ),
    );
  }

  Widget _popupMenuButton() {
    return PopupMenuButton(
      onSelected: (value) async {
        switch (value) {
          case NoteMenuActions.logout:
            {
              dev_tools.log(value.toString());
              final shouldLogout = await showLogoutDialog(context);
              dev_tools.log("should logout: $shouldLogout");
              if (shouldLogout) {
                await AuthService.firebase().logOut();
                _goToPage(Routes.homePageRoute);
              }
              break;
            }
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: NoteMenuActions.logout,
            child: ListTile(
              title: Text('Log Out'),
              horizontalTitleGap: 0,
              leading: Icon(Icons.exit_to_app),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ];
      },
    );
  }

  void _goToPage(String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
