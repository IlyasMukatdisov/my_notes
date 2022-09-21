import 'package:flutter/material.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import 'package:my_notes/utils/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;
  final String searchQuery;

  const NotesListView(
      {super.key,
      required this.notes,
      required this.onDeleteNote,
      required this.onTap,
      required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        if (searchQuery.isNotEmpty) {
          if (note.text.toLowerCase().contains(searchQuery.toLowerCase())) {
            return ListTile(
              onTap: () {
                onTap(note);
              },
              title: Text(
                note.text,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () async {
                  final shouldDelete = await showDeleteDialog(
                    context: context,
                  );
                  if (shouldDelete) onDeleteNote(note);
                },
              ),
            );
          } else {
            return Container();
          }
        } else {
          return ListTile(
            onTap: () {
              onTap(note);
            },
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(
                  context: context,
                );
                if (shouldDelete) onDeleteNote(note);
              },
            ),
          );
        }
      },
    );
  }
}
