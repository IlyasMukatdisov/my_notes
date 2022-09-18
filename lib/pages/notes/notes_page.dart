import 'package:flutter/material.dart';
import 'package:my_notes/utils/constants/routes.dart';
import 'package:my_notes/pages/notes/components/add_note_button.dart';
import 'package:my_notes/pages/notes/components/notes_list_view.dart';
import 'package:my_notes/pages/notes/components/note_popup_menu.dart';
import 'package:my_notes/services/auth/services/auth_service.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import 'package:my_notes/services/cloud/firebase_cloud_storage.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Notes'),
          actions: [
            addNoteButton(context),
            const NotePopUpMenu(),
          ],
        ),
        body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context1, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
                if (snapshot.hasData) {
                  final notes = snapshot.data as Iterable<CloudNote>;
                  return NotesListView(
                    notes: notes,
                    onDeleteNote: (note) async {
                      await _notesService.deleteNote(
                          documentId: note.documentId);
                    },
                    onTap: (note) {
                      Navigator.pushNamed(
                          context, Routes.createUpdateNotePageRoute,
                          arguments: note);
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
