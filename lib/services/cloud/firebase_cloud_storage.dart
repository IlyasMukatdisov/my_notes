import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_notes/services/cloud/cloud_note.dart';
import 'package:my_notes/services/cloud/cloud_storage_constants.dart';
import 'package:my_notes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection(notesCollection);

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) => notes
      .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
      .orderBy(noteDateFieldName, descending: true)
      .snapshots()
      .map((collection) =>
          collection.docs.map((doc) => CloudNote.fromSnapshot(doc)));

  // Stream<Iterable<CloudNote>> searchNotes(
  //     {required String ownerUserId, required String query}) {
  //   final allUserNotes = allNotes(ownerUserId: ownerUserId);
  //   for(var note in allUserNotes){

  //   }
  // }

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    DateTime now = DateTime.now();
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
      noteDateFieldName: now.toString()
    });
    final fetchedNote = await document.get();
    return CloudNote(
        documentId: fetchedNote.id,
        ownerUserId: ownerUserId,
        text: '',
        date: now.toString());
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
