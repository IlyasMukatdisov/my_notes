import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev_tools show log;

import 'package:my_notes/constants.dart';

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
          children: [
            const Text("Email Veryfied"),
          ],
        ),
      ),
    );
  }

  Widget _popupMenuButton() {
    return PopupMenuButton(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            {
              dev_tools.log(value.toString());
              final shouldLogout = await showLogoutDialog(context);
              dev_tools.log("should logout: $shouldLogout");
              if (shouldLogout) {
                await FirebaseAuth.instance.signOut();
                _goToLoginPage();
              }
              break;
            }
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: MenuAction.logout,
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

  void _goToLoginPage() {
    Navigator.pushNamedAndRemoveUntil(
        context, Constants.homePageRoute, (route) => false);
  }
}

enum MenuAction {
  logout,
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Log out'),
        content: Text('Are you sure want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
