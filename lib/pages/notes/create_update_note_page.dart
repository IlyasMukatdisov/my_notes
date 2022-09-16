import 'package:flutter/material.dart';
import 'package:my_notes/services/auth/services/auth_service.dart';
import 'package:my_notes/extensions/build_context/get_argument.dart';
import 'package:my_notes/services/cloud/firebase_cloud_storage.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import 'package:my_notes/utils/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNotePage extends StatefulWidget {
  const CreateUpdateNotePage({super.key});

  @override
  State<CreateUpdateNotePage> createState() => _CreateUpdateNotePageState();
}

class _CreateUpdateNotePageState extends State<CreateUpdateNotePage> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  void dispose() {
    _saveOrDeleteNote();
    _textController.dispose();
    super.dispose();
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    } else {
      final currentUser = AuthService.firebase().currentUser!;
      final userId = currentUser.id;
      final newNote = await _notesService.createNewNote(ownerUserId: userId);
      _note = newNote;
      return newNote;
    }
  }

  void _saveOrDeleteNote() async {
    final note = _note;
    final text = _textController.text;
    if (note != null) {
      if (text.isEmpty) {
        await _notesService.deleteNote(documentId: note.documentId);
      } else {
        await _notesService.updateNote(documentId: note.documentId, text: text);
      }
    }
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(documentId: note.documentId, text: text);
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Note'),
          actions: [
            IconButton(
              onPressed: () async {
                final text = _textController.text;
                if (_note == null || text.isEmpty) {
                  await showCannotShareEmptyNoteDialog(context: context);
                } else {
                  Share.share(text);
                }
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: FutureBuilder(
          future: createOrGetExistingNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                {
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
