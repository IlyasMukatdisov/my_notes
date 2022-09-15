class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

class CouldNotGetAllNoteException extends CloudStorageExceptions{}

class CouldNotCreateNoteException extends CloudStorageExceptions{}

class CouldNotUpdateNoteException extends CloudStorageExceptions{}

class CouldNotDeleteNoteException extends CloudStorageExceptions{}
