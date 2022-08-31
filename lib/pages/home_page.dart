import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/firebase_options.dart';
import 'package:my_notes/pages/login_page.dart';
import 'package:my_notes/pages/notes_page.dart';
import 'package:my_notes/pages/verify_email_page.dart';
import 'dart:developer' as dev_tools show log;

//comment
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initFireBase(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return _showPageDependOnCurrentUser(context);
            default:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
          }
        });
  }

  Future _initFireBase() async {
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Widget _showPageDependOnCurrentUser(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user == null) {
      return const LoginPage();
    }

    final bool emailVerified = user.emailVerified;

    if (emailVerified) {
      dev_tools.log('${user.email} is verified');
      return const NotesPage();
    }

    dev_tools.log('${user.email} is verified');
    return const VerifyEmailPage();

    //final uid = user?.uid ?? -1;
  }
}
