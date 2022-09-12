import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:my_notes/services/crud/cruid_exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory, MissingPlatformDirectoryException;
import 'package:path/path.dart' show join;

const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const idColumn = 'id';
const userIdColumn = 'user_id';
const emailColumn = 'email';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';

const createUserTable = '''
        CREATE TABLE IF NOT EXISTS "$userTable" (
          "$idColumn"	INTEGER NOT NULL,
          "$emailColumn"	TEXT NOT NULL UNIQUE,
          PRIMARY KEY("$idColumn" AUTOINCREMENT)
      );
    ''';

const createNoteTable = '''
        CREATE TABLE IF NOT EXISTS "$noteTable" (
        "$idColumn"	INTEGER NOT NULL,
        "$userIdColumn"	INTEGER NOT NULL,
        "$textColumn"	TEXT,
        "$isSyncedWithCloudColumn"	INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY("$idColumn" AUTOINCREMENT)
        );
      ''';

class NotesService {
  Database? _db;

  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance() {
    _noteStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _noteStreamController.sink.add(_notes);
      },
    );
  }
  factory NotesService() => _shared;

  List<DatabaseNote> _notes = [];

  Stream<List<DatabaseNote>> get allNotes => _noteStreamController.stream;

  late final StreamController<List<DatabaseNote>> _noteStreamController;

  Future<void> _cacheNotes() async {
    final notes = await getAllNotes();
    _notes = notes.toList();
    _noteStreamController.add(_notes);
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);

      await db.execute(createNoteTable);

      await _cacheNotes();
    } on MissingPlatformDirectoryException catch (e) {
      log(e.message);
      throw UnableToGetDocumentPathException();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      db.close();
      _db = null;
    }
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (deletedCount != 1) throw CouldNotDeleteUserException();
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      limit: 1,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isNotEmpty) {
      throw UserAlreadyExistException();
    }
    final userId = await db.insert(
      userTable,
      {
        emailColumn: email.toLowerCase(),
      },
    );

    return DatabaseUser(id: userId, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final result = await db.query(
      userTable,
      limit: 1,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isEmpty) {
      throw UserNotFoundException();
    } else {
      return DatabaseUser.fromRow(result.first);
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();

    final dbUser = await getUser(email: owner.email);

    if (dbUser != owner) {
      throw UserNotFoundException();
    } else {
      const text = '';

      final noteId = await db.insert(noteTable, {
        userIdColumn: owner.id,
        textColumn: text,
        isSyncedWithCloudColumn: 1
      });

      final note = DatabaseNote(
        id: noteId,
        userId: owner.id,
        text: text,
        isSyncedWithCloud: true,
      );

      _notes.add(note);
      _noteStreamController.add(_notes);

      return note;
    }
  }

  Future<void> deleteNote({required int noteId}) async {
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      noteTable,
      where: '$idColumn = ?',
      whereArgs: [noteId],
    );

    if (deleteCount == 0) {
      throw CouldNotDeleteNoteException();
    } else {
      _notes.removeWhere((note) => note.id == noteId);
      _noteStreamController.add(_notes);
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(noteTable);
    _notes = [];
    _noteStreamController.add(_notes);
    return numberOfDeletions;
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();
    final note = await db.query(
      noteTable,
      limit: 1,
      where: '$idColumn = ?',
      whereArgs: [id],
    );

    if (note.isEmpty) {
      throw NoteNotFoundException();
    } else {
      final updNote = DatabaseNote.fromRow(note.first);
      _notes.removeWhere((myNote) => myNote.id == id);
      _notes.add(updNote);
      _noteStreamController.add(_notes);
      return updNote;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);

    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();

    await getNote(id: note.id);

    final updatesCount = await db.update(
        noteTable, {textColumn: text, isSyncedWithCloudColumn: 0},
        where: '$idColumn = ?', whereArgs: [note.id]);

    if (updatesCount == 0) {
      throw CouldNotUpdateNoteException();
    } else {
      final updNote = await getNote(id: note.id);
      _notes.removeWhere((nNote) => nNote.id == updNote.id);
      _notes.add(updNote);
      _noteStreamController.add(_notes);
      return updNote;
    }
  }

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on UserNotFoundException {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      //
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => "User: id = $id | email = $email";

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  const DatabaseNote(
      {required this.id,
      required this.userId,
      required this.text,
      required this.isSyncedWithCloud});

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 0 ? false : true;

  @override
  String toString() =>
      "Note: id = $id | text = '$text' | user_id = $userId | is_synced_with_cloud = $isSyncedWithCloud";

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
