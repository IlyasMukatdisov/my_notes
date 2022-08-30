import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/firebase_options.dart';


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
                _checkCurrentUser(context);
                return Container();
              default:
                // ignore: prefer_const_constructors
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

  void _checkCurrentUser(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final bool emailVerified = user?.emailVerified ?? false;

    if (emailVerified) {
      debugPrint('Veryfied email');
    } else {
      debugPrint('Not verified email');
    }

    final uid = user?.uid ?? -1;
  }
}
