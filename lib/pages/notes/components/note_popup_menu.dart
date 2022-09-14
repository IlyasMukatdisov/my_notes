import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/enums/note_menu_actions.dart';
import 'package:my_notes/utils/dialogs/logout_dialog.dart';
import 'package:my_notes/services/auth/services/auth_service.dart';

class NotePopUpMenu extends StatefulWidget {
  const NotePopUpMenu({super.key});

  @override
  State<NotePopUpMenu> createState() => _NotePopUpMenuState();
}

class _NotePopUpMenuState extends State<NotePopUpMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) async {
        switch (value) {
          case NoteMenuActions.logout:
            {
              final shouldLogout = await showLogOutDialog(context: context);
              if (shouldLogout) {
                await AuthService.firebase().logOut();
                if (!mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.loginPageRoute, (route) => false);
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
}
