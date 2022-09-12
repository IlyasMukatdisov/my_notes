import 'package:flutter/material.dart';
import 'package:my_notes/services/auth/services/auth_service.dart';
import 'package:my_notes/services/crud/notes_service.dart';

class NewNotePage extends StatefulWidget {
  const NewNotePage({super.key});

  @override
  State<NewNotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null)
      return existingNote;
    else {
      final currentUser = AuthService.firebase().currentUser!;
      final email = currentUser.email!;
      return await _notesService.createNote(
          owner: await _notesService.getUser(email: email));
    }
  }

  void _saveOrDeleteNote() async {
    final note = _note;
    final text = _textController.text;
    if (note != null) {
      if (text.isEmpty) {
        await _notesService.deleteNote(noteId: note.id);
      } else {
        await _notesService.updateNote(note: note, text: text);
      }
    }
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(note: note, text: text);
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _textController = TextEditingController();
    _notesService = NotesService();
    super.initState();
  }

  @override
  void dispose() {
    _saveOrDeleteNote();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('New note')),
        body: FutureBuilder(
          future: createNewNote(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                {
                  _note = snapshot.data as DatabaseNote;
                  _setupTextControllerListener();
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                          hintText: 'Start typing your note...'),
                    ),
                  );
                }
              default:
                return const Center(
                    child: CircularProgressIndicator.adaptive());
            }
          },
        ));
  }
}
