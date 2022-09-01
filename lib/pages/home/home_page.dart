import 'package:flutter/material.dart';
import 'package:my_notes/pages/login/login_page.dart';
import 'package:my_notes/pages/notes/notes_page.dart';
import 'package:my_notes/pages/verify_email/verify_email_page.dart';
import 'package:my_notes/services/auth/services/auth_service.dart';

//comment
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
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

  Widget _showPageDependOnCurrentUser(BuildContext context) {
    final user = AuthService.firebase().currentUser;

    if (user == null) {
      return const LoginPage();
    }

    if (user.isEmailVerified) {
      return const NotesPage();
    }
    return const VerifyEmailPage();
    //final uid = user?.uid ?? -1;
  }
}
