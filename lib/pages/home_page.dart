import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/firebase_options.dart';
import 'package:my_notes/pages/login_page.dart';
import 'package:my_notes/pages/verify_email_page.dart';

//comment
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: FutureBuilder(
          future: _initFireBase(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return // _checkCurrentUser(context);
                    LoginPage();
              default:
                return Center(
                  child: const CircularProgressIndicator(),
                );
            }
          }),
    );
  }

  Future _initFireBase() async {
    return Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Widget _checkCurrentUser(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final bool emailVerified = user?.emailVerified ?? false;

    debugPrint(user?.email);
    if (emailVerified) {
      debugPrint('Veryfied email');
      return Container(
        child: Text("Veryfied"),
      );
    } else {
      debugPrint('Not verified email');
      return VerifyEmailPage();
    }

    //final uid = user?.uid ?? -1;
  }
}
