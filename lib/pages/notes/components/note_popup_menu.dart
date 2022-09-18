import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:my_notes/utils/constants/routes.dart';
import 'package:my_notes/utils/enums/note_menu_actions.dart';
import 'package:my_notes/services/auth/bloc/auth_bloc.dart';
import 'package:my_notes/services/auth/bloc/auth_event.dart';
import 'package:my_notes/utils/dialogs/logout_dialog.dart';
class NotePopUpMenu extends StatefulWidget {
  const NotePopUpMenu({super.key});

  @override
  State<NotePopUpMenu> createState() => _NotePopUpMenuState();
}

class _NotePopUpMenuState extends State<NotePopUpMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (action) async {
        switch (action) {
          case NoteMenuActions.logout:
            {
              final shouldLogout = await showLogOutDialog(context: context);
              if (shouldLogout) {
                if (!mounted) return;
                context.read<AuthBloc>().add(
                  const AuthEventLogOut()
                );
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
