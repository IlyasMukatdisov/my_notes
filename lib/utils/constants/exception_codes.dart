abstract class FirebaseExceptionCodes {
  //login codes
  static const String userDisabled = 'user-disabled';
  static const String userNotFound = 'user-not-found';
  static const String wrongPassword = 'wrong-password';

  //register codes  
  static const String emailAlreadyInUse = 'email-already-in-use';
  static const String operationNotAllowed = 'operation-not-allowed';
  static const String weakPassword = 'weak-password';

  //both login and register
  static const String invalidEmail = 'invalid-email';
}
