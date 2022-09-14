import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev_tools show log;

import 'package:my_notes/constants/routes.dart';
import 'package:my_notes/enums/note_menu_actions.dart';
import 'package:my_notes/pages/notes/components/notes_list_view.dart';
import 'package:my_notes/pages/utils/dialogs/logout_dialog.dart';
import 'package:my_notes/services/auth/services/auth_service.dart';
import 'package:my_notes/services/crud/notes_service.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Notes'),
          actions: [
            _addNoteButton(),
            _popupMenuButton(),
          ],
        ),
        body: FutureBuilder(
          future: _notesService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context1, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                      case ConnectionState.waiting:
                        if (snapshot.hasData) {
                          final notes = snapshot.data as List<DatabaseNote>;
                          return NotesListView(
                              notes: notes,
                              onDeleteNote: (note) async {
                                await _notesService.deleteNote(noteId: note.id);
                              });
                        } else {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                      default:
                        return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }

  Widget _popupMenuButton() {
    return PopupMenuButton(
      onSelected: (value) async {
        switch (value) {
          case NoteMenuActions.logout:
            {
              dev_tools.log(value.toString());
              final shouldLogout = await showLogOutDialog(context: context);
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

  Widget _addNoteButton() {
    return IconButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.newNotePageRoute);
        },
        icon: const Icon(Icons.note_add));
  }
}
