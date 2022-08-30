import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/firebase_options.dart';
import 'package:my_notes/pages/after_verified_page.dart';
import 'package:my_notes/pages/login_page.dart';
import 'package:my_notes/pages/verify_email_page.dart';

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
              return Center(
                child: const CircularProgressIndicator(),
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
      return LoginPage();
    } else {
      final bool emailVerified = user.emailVerified;

      if (emailVerified) {
        debugPrint('${user.email} is verified');
        return AfterVerifiedPage();
      } else {
        debugPrint('${user.email} is verified');
        return VerifyEmailPage();
      }
    }

    //final uid = user?.uid ?? -1;
  }
}
