import 'dart:async';

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
  late final TextEditingController _controller;

  Timer? debouncer;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _controller = TextEditingController();
    _controller.addListener(() {
      if (_controller.text.isNotEmpty) {
        debounce(() {
          setState(() {});
        });
      } else {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (value) {
              if (_controller.text.isNotEmpty) {
                setState(() {});
              }
            },
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            controller: _controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search notes',
              hintStyle: const TextStyle(color: Colors.white),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    setState(() {});
                  }
                },
              ),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
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
                  Iterable<CloudNote> result;
                  final notes = snapshot.data as Iterable<CloudNote>;
                  String name = _controller.text;
                  if (name.isEmpty) {
                    result = notes;
                  } else {
                    List<CloudNote> foundedNotes = [];
                    for (var note in notes) {
                      if (note.text.contains(name.toLowerCase())) {
                        foundedNotes.add(note);
                      }
                    }
                    result = foundedNotes;
                  }
                  return notes.isNotEmpty
                      ? NotesListView(
                          notes: result,
                          onDeleteNote: (note) async {
                            await _notesService.deleteNote(
                                documentId: note.documentId);
                          },
                          onTap: (note) {
                            Navigator.pushNamed(
                                context, Routes.createUpdateNotePageRoute,
                                arguments: note);
                          },
                        )
                      : const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Your notes are empty. In order to add note please tap on plus button",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  void _search() {}
}
