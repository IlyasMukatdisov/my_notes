import 'package:firebase_core/firebase_core.dart';
import 'package:my_notes/utils/constants/exception_codes.dart';
import 'package:my_notes/firebase_options.dart';
import 'package:my_notes/services/auth/providers/auth_provider.dart';
import 'package:my_notes/services/auth/models/auth_user.dart';
import 'package:my_notes/services/auth/auth_exceptions.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case FirebaseExceptionCodes.emailAlreadyInUse:
          throw EmailAlreadyInUseAuthException();
        case FirebaseExceptionCodes.invalidEmail:
          throw InvalidEmailAuthException();
        case FirebaseExceptionCodes.operationNotAllowed:
          throw OperationNotAllowedAAuthException();
        case FirebaseExceptionCodes.weakPassword:
          throw WeakPasswordAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    return user != null ? AuthUser.fromFirebase(user) : null;
  }

  @override
  Future<AuthUser> logIn(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case FirebaseExceptionCodes.invalidEmail:
          throw InvalidEmailAuthException();
        case FirebaseExceptionCodes.userNotFound:
          throw UserNotFoundAuthException();
        case FirebaseExceptionCodes.userDisabled:
          throw UserDisabledAuthException();
        case FirebaseExceptionCodes.wrongPassword:
          throw WrongPasswordAuthException();
        default:
          throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
}
